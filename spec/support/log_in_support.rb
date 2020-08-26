module LogInSupport
  def basic_auth
    user_name = ENV['BASIC_AUTH_USER']
    password = ENV['BASIC_AUTH_PASSWORD']
    visit "http://#{user_name}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
  end

  def login(user)
    login_as(user, scope: :user)
    visit root_path
  end
end
