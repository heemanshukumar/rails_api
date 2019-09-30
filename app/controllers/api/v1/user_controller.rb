class Api::V1::UsersController < Api::V1::ApplicationController

	skip_before_action :authenticate, only: [:validate_otp]

	def me
		render json: { id: current_user.id, email: current_user.email, username: current_user.username, two_factor_enabled: current_user.two_factor_enabled }
    end
    
	def enable_otp_validate_auth
		if current_user.current_otp == params[:user][:code]
			enable_otp
		else
			render json: {success: false, message: "Please Enter a valid code"}
		end
	end

	def disable_otp_validate_auth
		if two_factor_auth_verified?(params[:user][:code])
			disable_otp
		else
			render json: {success: false, message: "Please Enter a valid code"}
		end
	end

	def validate_otp
		user = User.where(["lower(username) = :value OR lower(email) = :value", {value: params[:user][:login].strip.downcase}]).first
    	if(user.current_otp == params[:user][:code])
            sign_in(:user, user)
            jwt = Auth.issue({user: user.id})
            
            render json: {  success: true,
                            access_token: jwt,
                            user: user.as_json(only: [:id, :email, :username, :two_factor_enabled, :portfolio_type]),
                            location: Geocoder.search(ip).first.try(:country)
                        }
        else
        	render json: {success: false }
        end
	end
end