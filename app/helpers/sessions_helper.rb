module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
#    if session[:user_id]
#      @current_user ||= User.find_by(id: session[:user_id])
#    end
    # 一時セッションの中にuser_idがあるか
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    # 永続化cookieの中に暗号化されたuser_idがあるか
    # cookieメソッドがリクエストヘッダから読み出して暗号化を解く
    elsif(user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      # userがぞんざいし、トークンがあればダイジェスト化し、dbに保存しているダイジェストと比較する
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
end
