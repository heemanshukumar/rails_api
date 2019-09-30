class Api::V1::RegistrationsController < ActionController::Base

  def create
  	p "abc"
  	begin
    	ActiveRecord::Base.transaction do
        if params[:user][:password] == 	params[:user][:password_confirmation]
  	    	@user = User.new(user_params)
  	    	if @user.save
            @token = @user.api_tokens.create(token: @user.generate_token)
  	    		render json: {
  	    			success: true,
    					message: "User registered successfully!",
              token: @token.token
  	    		}
  	    	else
  	    		render json:{
  	    			success: false,
  		      	message: @user.errors.full_messages.join(", ")
  	    		}
  	    	end
        else
          render json:{
            success: false,
            message: "Password does not match"
          }
        end
	    end
    rescue Exception => err
    	render json:{
  			success: false,
      	message: err.message
  		}
    end
  end

  

	private
		def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end