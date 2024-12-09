class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  include RequestExceptionHandler
  include Pundit::Authorization
  include SwitchLocale

  skip_before_action :verify_authenticity_token

  before_action :set_current_user, unless: :devise_controller?
  around_action :switch_locale
  around_action :handle_with_exception, unless: :devise_controller?
  before_action :validate_last_accessed, unless: :devise_controller?

  private

  def set_current_user
    @user ||= current_user
    Current.user = @user
  end

  def validate_last_accessed
    return unless current_user # Check if current_user is not nil

    last_activity = redis_get_last_activity
    if last_activity.nil? || last_activity < 35.minutes.ago
      current_user.tokens = {}
      current_user.save
    else
      redis_set_last_activity
    end
  end

  def redis_get_last_activity
    Redis::Alfred.get("user:#{current_user.id}:last_activity_at")
  end

  def redis_set_last_activity
    Redis::Alfred.set("user:#{current_user.id}:last_activity_at", Time.current.to_s)
  end

  def pundit_user
    {
      user: Current.user,
      account: Current.account,
      account_user: Current.account_user
    }
  end
end
ApplicationController.include_mod_with('Concerns::ApplicationControllerConcern')
