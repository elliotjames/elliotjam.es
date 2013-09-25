get '/' do
  redirect '/blog'
end

get '/blog' do
  @selected_tab = :blog

  page_offset = params[:page].to_i * settings.posts_per_page

  @posts = Post.order('created_at DESC').offset(page_offset).limit(settings.posts_per_page)

	erb :'posts/index'
end

get '/blog/*/*' do |year, reference_id|
  @selected_tab = :blog
  @post = Post.where("date_part('year', created_at) = ? AND reference_id = ?", year, reference_id).first
  erb :'posts/show'
end

post '/posts' do
  @post = Post.new(params[:post])
  if @post.save
    redirect "/posts/#{@post.id}"
  else
    redirect '/posts/new'
  end
end

get '/posts/new', :auth => :admin do
  @selected_tab = :blog
  @post = Post.new
  erb :'posts/new'
end

get '/posts/:id' do
  @selected_tab = :blog
  @post = Post.find(params[:id])
  erb :'posts/show'
end

put '/posts/:id', :auth => :admin do
  @post = Post.find(params[:id])
  if @post.update_attributes(params[:post])
    erb :'posts/show'
  else
    redirect "/posts/#{@post.id}/edit"
  end
end

delete '/posts/:id', :auth => :admin do
  if Post.find(params[:id]).destroy
    redirect '/blog'
  else
    redirect "/posts/#{@post.id}"
  end
end

get '/posts/:id/edit', :auth => :admin do
  @selected_tab = :blog
  @post = Post.find(params[:id])
  erb :'posts/edit'
end