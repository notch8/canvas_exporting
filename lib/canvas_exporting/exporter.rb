require 'fileutils'
require 'tempfile'
require 'phantomjs'

# references:
#   http://www.highcharts.com/docs/export-module/export-module-overview
#   https://github.com/highslide-software/highcharts.com/tree/master/exporting-server/phantomjs
module CanvasExporting
  module Exporter
    def export
      @infile_tmp_file = infile_file

      type = params[:type] || 'image/png'
      extension = MIME::Types[type].first.extensions.first

      if params[:outputpath] == nil
        output_path = tmp_dir
      else
        output_path = params[:outputpath]
      end

      output_path = output_path + '/' if output_path[-1] != '/'

      if params[:filename] == nil
        filename = 'Chart.' + extension
      else
        filename = params[:filename]
      end

      @output_file = output_path + filename

      if params[:colorset] == nil
        color_set = ""
      else
        color_set = params[:colorset]
      end

      #Rails.logger.debug "colorset: #{color_set}"

      scale = params[:scale] || 2
      width = params[:width] || 400
      constr = params[:constr] || 'Chart'

      convert_args = convert_args({infile: @infile_tmp_file.path,
                                   outfile: @output_file,
                                   scale: scale,
                                   width: width,
                                   constr: constr,
                                   callback: callback_path,
                                   colorset: color_set
                                  })

      result = ::Phantomjs.run(*convert_args)
      #puts result if VERBOSE

      # TODO: clean @output_tmp_file
      @infile_tmp_file.delete
      @callback_tmp_file.delete if @callback_tmp_file

      if /Error/ =~ result
        render text: result, status: 500
      else
        send_file @output_file, filename: "#{filename}", type: type
      end
    end

    protected
    def tmp_dir
      Rails.root.join('tmp/canvas_charts').to_s.tap { |f| FileUtils.mkdir_p f }
    end

    def infile_file
      begin
        tmp_file = nil
        if params[:options]
          tmp_file = Tempfile.new(['options', '.json'], tmp_dir)
          temp_write(tmp_file, params[:options])
        elsif params[:svg]
          tmp_file = Tempfile.new(['options', '.svg'], tmp_dir)
          temp_write(tmp_file, params[:svg])
        end
      rescue e
        logger.debug ("infile_file in exporter.rb.  Exception: #{e}")
        raise e
      end
      tmp_file
    end

    def callback_path
      if params[:callback]
        @callback_tmp_file = Tempfile.new(['callbacks', '.js'], tmp_dir)
        temp_write(@callback_tmp_file, params[:callback])
        @callback_tmp_file.path
      else
        nil
      end
    end

    def convert_args(args)
      convert_args = args.reject { |k, v| v.blank? }.to_a.map { |pair| ["-#{pair[0]}", pair[1].to_s] }.flatten

      convert_args.unshift("--web-security=false", convert_js_path)
    end

    def convert_js_path
      File.join(ROOT, 'phantomjs/canvas-convert.js').to_s
    end

    def temp_write(tmp_file, content)
      File.open(tmp_file.path, 'r+') do |f|
        f.write content
      end
    end
  end
end
