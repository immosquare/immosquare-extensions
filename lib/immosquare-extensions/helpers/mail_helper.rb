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
          :formats => get_email_formats(email).map do |format|
                        name = format.split("/").last
                        {:name => name, :url => url_for(:part => name)}
                      end,
          :locales => I18n.available_locales.map do |locale|
            {:name => locale, :url => url_for(:mailer_locale => locale)}
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
                  <%= link_to(format[:name], format[:url]) %>
                  <%= content_tag(:span, " | ") unless format == formats.last %>
                <% end %>
                </td>
              </tr>

              <% if locales.size > 1 %>
              <tr>
                <th>Locale:</th>
                <td>
                  <% locales.each do |locale| %>
                    <%= link_to(locale[:name], locale[:url]) %>
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
        availabe_formats = get_email_formats(email)
        part_format      = params[:part].present? ? availabe_formats.find {|format| format.end_with?(params[:part]) } : availabe_formats.first
        part_format      = availabe_formats.first if part_format.nil?
        parts            = get_email_parts(email)
        parts.find {|part| part[:content_type] == part_format }[:body]
      rescue StandardError => e
        "Error displaying email: #{e.message}"
      end
    end

    private


    ##============================================================##
    ## Return email formats
    ## ["text/plain", "text/html"]
    ## ["text/html"]
    ## ["text/plain"]
    ##============================================================##
    def get_email_formats(email)
      content_types         = email.parts.map(&:content_type)
      content_types_allowed = ["text/html", "text/plain"]
      if !email.multipart? || content_types.empty?
        if email.header_fields.nil? || email.header_fields.empty?
          ["text/plain"]
        else
          header       = email.header_fields.find {|header| header.name == "Content-Type" }
          [header.nil? || !content_types_allowed.include?(header.value) ? "text/plain" : header.value]
        end
      else
        content_types.map do |content_type|
          content_type = content_type.split(";").first
          content_types_allowed.include?(content_type) ? content_type : nil
        end
          .compact.sort_by do |content_type|
          content_types_allowed.index(content_type)
        end
      end
    end

    ##============================================================##
    ## Return email parts with content type and body
    ##============================================================##
    def get_email_parts(email)
      parts_type = email.parts.map(&:content_type)
      if !email.multipart? || parts_type.empty?
        if email.header_fields.nil? || email.header_fields.empty?
          content_type = "text/plain"
        else
          header       = email.header_fields.find {|header| header.name == "Content-Type" }
          content_type = header.nil? ? "text/plain" : header.value
        end
        [{
          :content_type => content_type,
          :body         => content_type == "text/plain" ? simple_format(email.body.decoded) : email.body.decoded
        }]
      else
        email.parts.map do |part|
          content_type = part.content_type.split(";").first
          {
            :content_type => content_type,
            :body         => content_type == "text/plain" ? simple_format(part.body.decoded) : part.body.decoded
          }
        end
      end
    end
  end
end
