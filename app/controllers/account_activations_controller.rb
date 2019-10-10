class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    # activateしていてactivation_digestでトークンが認証ができるか
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      # activatedフラグ、時刻更新
      # user.update_attribute(:activated, true)
      # user.update_attribute(:activated_at, Time.zone.now)
      user.activate

      # ログイン
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
