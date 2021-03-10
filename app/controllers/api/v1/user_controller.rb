class Api::V1::UsersController < Api::V1::ApplicationController 
	

	def update_terms
		if params[:user][:terms_accepted].present? 

			if @user.update(terms_accepted: true)
				render json:{
					success: true
				}
			else
				render json:{
					success: false,
					message: @user.errors.full_messages.join(', ')
				}
			end
		else
			render json:{
				success: false,
				message: "Please accept privacy and eligibility."
			}
		end
	end

	def user_details
		render json: {
			success: true,
			user: @user
		}
	end

	def recheck_terms
	    if @user.terms_accepted
	      render json:{
		success: true}
	    else
	      render json:{
		success: false,
		message: 'Please accept privacy and eligibility'
	      }
	    end
  	end




end
