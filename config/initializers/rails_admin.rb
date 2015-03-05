RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  config.authenticate_with do
    authenticate_or_request_with_http_basic("#{ENV['BASIC_AUTH_USERNAME']}:#{ENV['BASIC_AUTH_PASSWORD']}") do |username, password|
      username == ENV['BASIC_AUTH_USERNAME'] && password == ENV['BASIC_AUTH_PASSWORD']
    end
  end

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration
  config.model 'Comment' do
    list do
      field :created_at
      field :location
      field :username
      field :content
      field :accepted
    end
  end

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
