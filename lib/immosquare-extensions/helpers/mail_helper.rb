module ImmosquareExtensions
  module MailHelper
    ##============================================================##
    ## Inspired by:
    ## https://github.com/rails/rails/blob/main/railties/lib/rails/templates/rails/mailers/email.html.erb
    ## -------------
    ## Here concact with "#{}" is not working, so used
    ## "data:application/octet-stream;charset=utf-8;base64,"+Base64.encode64(a.body.to_s)
    ##============================================================##
    def display_email_header_infos(email)
      ApplicationController.render(
        :layout => false,
        :locals => {
          :email   => email,
          :formats => get_email_formats(email),
          :locales => I18n.available_locales.map do |locale|
            {
              :name      => locale,
              :url       => url_for(:mailer_locale => locale, :part => params[:part].presence),
              :css_class => (params[:mailer_locale].present? && params[:mailer_locale] == locale.to_s) || (params[:mailer_locale].blank? && I18n.locale == locale) ? "" : "text-body"
            }
          end
        },
        :inline => <<~HTML
          <header>
            <table>
              <% if email.respond_to?(:smtp_envelope_from) && Array(email.from) != Array(email.smtp_envelope_from) %>
                <tr>
                  <th>SMTP-From:</th>
                  <td><%= email.smtp_envelope_from %></td>
                </tr>
              <% end %>

              <% if email.respond_to?(:smtp_envelope_to) && email.to != email.smtp_envelope_to %>
                <tr>
                  <th>SMTP-To:</th>
                  <td><%= email.smtp_envelope_to %></td>
                </tr>
              <% end %>

              <tr>
                <th>From:</th>
                <td><%= email.header["from"] %></td>
              </tr>

              <% if email.reply_to %>
                <tr>
                  <th>Reply-To:</th>
                  <td><%= email.header["reply-to"] %></td>
                </tr>
              <% end %>

              <tr>
                <th>To:</th>
                <td><%= email.header["to"] %></td>
              </tr>

              <% if email.cc %>
                <tr>
                  <th>CC:</th>
                  <td><%= email.header["cc"] %></td>
                </tr>
              <% end %>

              <% if email.bcc %>
                <tr>
                  <th>BCC:</th>
                  <td><%= email.header["bcc"] %></td>
                </tr>
              <% end %>

              <tr>
                <th>Date:</th>
                <td><%= Time.current.rfc2822 %></td>
              </tr>

              <tr>
                <th>Subject:</th>
                <td><%= email.subject %></td>
              </tr>

              <tr>
                <th>Formats:</th>
                <td>
                <% formats.each do |format| %>
                  <%= link_to(format[:name], format[:url], :class => "text-decoration-none hover-primary" + " " + format[:css_class]) %>
                  <%= content_tag(:span, " | ") unless format == formats.last %>
                <% end %>
                </td>
              </tr>

              <% if locales.size > 1 %>
              <tr>
                <th>Locale:</th>
                <td>
                  <% locales.each do |locale| %>
                    <%= link_to(locale[:name], locale[:url], :class => "text-decoration-none hover-primary" + " " + locale[:css_class]) %>
                    <%= content_tag(:span, " | ") unless locale == locales.last %>
                  <% end %>
                </td>
              </tr>
              <% end %>

              <% if !(email.attachments.nil? || email.attachments.empty?) %>
                <tr>
                  <th>Attachments:</th>
                  <td>
                  <% email.attachments.each do |a| %>
                    <% filename = a.respond_to?(:original_filename) ? a.original_filename : a.filename %>
                    <%= link_to filename, "data:application/octet-stream;charset=utf-8;base64,"+Base64.encode64(a.body.to_s), download: filename %>
                  <% end %>
                  </td>
                </tr>
              <% end %>

              <% if !(email.header_fields.nil? || email.header_fields.empty?) %>
                <tr>
                  <th class="align-top">Headers:</th>
                  <td>
                    <details>
                      <summary>Show all headers</summary>
                      <table>
                        <% email.header_fields.each do |field| %>
                          <tr>
                            <th><%= field.name %>:</th>
                            <td><%= field.value %></td>
                          </tr>
                        <% end %>
                      </table>
                    </details>
                  </td>
                </tr>
              <% end %>
            </table>
          </header>
        HTML
      )
    end

    def display_email_preview(email)
      begin
        formats     = get_email_formats(email)
        part_format = formats.find {|f| f[:selected] }
        part_type   = Mime::Type.lookup(part_format[:content_type])

        raise("No email part found for content type: #{part_format[:content_type]}") if !(part = find_part(email, part_type))

        body = part.respond_to?(:decoded) ? part.decoded : part
        part_format[:name] == "html" ? body.html_safe : simple_format(body)
      rescue StandardError => e
        "Error displaying email: #{e.message}"
      end
    end

    private


    ##============================================================##
    ## find_first_mime_type is a method from the Mail gem for module
    ## Mail Message
    ## ----------------
    ## https://github.com/mikel/mail/blob/master/lib/mail/message.rb#L1938
    ##============================================================##
    def find_preferred_part(email, *formats)
      formats.each do |format|
        if (part = email.find_first_mime_type(format))
          return part
        end
      end

      email if formats.any? {|f| email.mime_type == f }
    end

    ##============================================================##
    ## find_part use the find_first_mime_type method from the Mail
    ## gem for module Mail Message
    ##============================================================##
    def find_part(email, format)
      if (part = email.find_first_mime_type(format))
        part
      elsif email.mime_type == format
        email
      end
    end

    ##============================================================##
    ## Return email formats
    ##============================================================##
    def get_email_formats(email)
      part    = find_preferred_part(email, Mime[:html], Mime[:text])
      formats = []
      formats =
        if email.html_part && email.text_part
          selected = params[:part].present? && params[:part] == "text" ? "text" : "html"
          [
            {:name => "html", :content_type => "text/html",  :url => url_for(:part => "html", :mailer_locale => params[:mailer_locale].presence), :selected => selected == "html",  :css_class => selected == "html" ? "" : "text-body"},
            {:name => "text", :content_type => "text/plain", :url => url_for(:part => "text", :mailer_locale => params[:mailer_locale].presence), :selected => selected == "text",  :css_class => selected == "text" ? "" : "text-body"}
          ]
        elsif part
          data = part.content_type.split(";").first.split("/").last
          [
            {:name => data, :content_type => "text/#{data}", :url => url_for(:part => data, :mailer_locale => params[:mailer_locale].presence), :selected => true,  :css_class => ""}
          ]
        end
    end
  end
end
