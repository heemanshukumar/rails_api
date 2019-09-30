class Api::V1::SessionsController <  ActionController::Base

	def create
		begin
			if params[:contact].present? && params[:password].present?
				user = User.find_by_contact(params[:contact])
				unless user.blank?
					if user.valid_password?(params[:password])
						sign_in(:user, user)
						@token = user.api_tokens.create(token: user.generate_token)
					  render json:{
					  	success: true,
					  	message: "Login Successfully",
					  	token: @token.token
					  }
					else
						render json:{
				  		success: false,
				  		message: "Invalid contact or password"
						}
					end
				else
					render json:{
				  	success: false,
				  	message: "Invalid contact or password"
					}
				end
			else
				render json:{
			  	success: false,
			  	message: "Contact or Password not present"
			  }
			end
		rescue Exception => err
			render json:{
		  	success: false,
		  	message: err.message
		  }
		end
	end

	def destroy
			
			@token = ApiToken.where(token: params[:id], expire: nil).last
			if @token.present?
				if @token.update_attributes(expire: Time.zone.now)
					render json: { 
						success: true, 
						message: "Log Out successfully",
						token: ""
					}
				
				end
			end

	end
end