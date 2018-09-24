require './config/environment'

class ProjectController < ApplicationController

  get '/projects' do
    if Helpers.is_logged_in?(session)
      @projects = Project.all
      erb :'projects/projects'
    else
      redirect '/login'
    end
  end


  get 'projects/projects' do
   if Helpers.is_logged_in?(session)
     @user = Helpers.current_user(session)
     erb :'projects/projects'
   else
     redirect '/login'
   end
 end

  post '/projects' do
    @user = Helpers.current_user(session)
    if !params[:project_name].empty? && Project.where(project_name: params['project_name']).exists? == false
        @Project = @user.projects.create(project_name: params[:project_name],description: params[:description],content: params[:content],contributors: session[:username])
        erb :'/projects/projects'
    else
      flash[:message] = "Please enter a valid project name."
      redirect '/projects/new'
    end
  end

  get '/projects/new' do
    if Helpers.is_logged_in?(session)
      erb :'projects/new'
    else
      redirect '/login'
    end
  end

  get '/projects/:slug' do
    if Helpers.is_logged_in?(session)
      @user = Helpers.current_user(session)
      @project = @user.projects.find_by_slug(params[:slug])
      erb :'projects/projects'
    else
      redirect '/login'
    end
  end

  get '/projects/:slug/show' do
    if Helpers.is_logged_in?(session)
      @user = Helpers.current_user(session)
      @project = @user.projects.find_by_slug(params[:slug])
      erb :'/projects/show'
    else
      redirect '/login'
    end
  end

  post '/projects/:slug/delete' do
    if Helpers.is_logged_in?(session)
      @user = Helpers.current_user(session)
      @project = @user.projects.find_by_slug(params[:slug])

      if @user.user_id == @project.user_id
        @project.destroy
        erb :'users/index'
      else
          flash[:message] = "You do not have permission to delete this project"
          erb :'projects/edit_projects'
      end
    else
      redirect '/login'
    end
  end

  get '/projects/:slug/edit' do
    if Helpers.is_logged_in?(session)
      @user = Helpers.current_user(session)
      @project = @user.projects.find_by_slug(params[:slug])
      erb :'projects/edit_projects'
    else
      redirect '/login'
    end
  end

  post '/projects/:slug/edit' do
    if Helpers.is_logged_in?(session)
      @user = Helpers.current_user(session)
      @project = @user.projects.find_by_slug(params[:slug])
      @project.update(content: params[:content])
      @project.save
      erb :'/projects/show'
    end
  end
end
