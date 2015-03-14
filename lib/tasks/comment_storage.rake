namespace :comment_storage do
  desc "Import comments from wordpress exported xml"
  task :wpimport do
    doc = ::Nokogiri::XML(File.open(ENV["WPXML_PATH"]).read)

    comments = []

    doc.search('item').each do |item|
      item_link = item.at('link').text
      item.search('wp|comment').each do |wpcomment|
        comment = {
          location: item_link,
          username: wpcomment.at('wp|comment_author').text,
          link: wpcomment.at('wp|comment_author_url').text,
          mail: wpcomment.at('wp|comment_author_email').text,
          remote_ip: wpcomment.at('wp|comment_author_IP').text,
          content: wpcomment.at('wp|comment_content').text,
          accepted: wpcomment.at('wp|comment_approved').text,
          commented_at: wpcomment.at('wp|comment_date').text
        }
        comments.push(comment)
      end
    end
    # TODO: exclude non approved comment instead of including accepted flag in params

    agent = Mechanize.new

    comments.each do |comment|
      params = {}.tap do |comment_params|
        comment.each do |k, v|
          comment_params["comment[#{k}]"] = v
        end
      end
      params.merge!({client_key: ENV["CLIENT_KEY"]})
      # TODO: prevent doubled post
      agent.post "https://#{ENV['COMMENT_STORAGE_HOST']}/comments", params, { "HTTP_ACCEPT" => "application/json" }
    end
  end
end