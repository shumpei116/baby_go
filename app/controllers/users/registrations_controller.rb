# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: :create
  before_action :configure_account_update_params, only: :update
  before_action :ensure_normal_user, only: %i[update destroy]

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name avatar])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: %i[name introduction avatar avatar_cache remove_avatar])
  end

  def after_update_path_for(resource)
    user_path(resource)
  end

  private

  def ensure_normal_user
    redirect_to root_path, alert: 'ゲストユーザーのアカウント更新はできません' if resource.email == 'guest@example.com'
  end
end
