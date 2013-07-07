require 'pry'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'active_support/all'
require 'pg'


before do
  q = "SELECT genre FROM video"
  @superselect = run_sql(q)
end

get '/' do
  erb :home
end

get '/new' do
  erb :new
end

post '/create' do

  q = "INSERT INTO video (name, title, description, url, genre)
          VALUES ('#{params['name']}', '#{params['title']}', '#{params['description']}', '#{params['url'].gsub("watch?v=", "embed/")}', '#{params['genre']}')"

          #raise q + " " + params[:origin]

          run_sql(q)
          redirect to('/videos')
          # binding.pry
end


 #      fixit do
 #            def @url(" #{params['url']} == '                    '          ")
 #              Rack::Utils.url.erb("      ")
 #            end
 #          end


 # def unescape(s)
 #       s.tr('+', ' ').gsub(/((?:%[0-9a-fA-F]{2})+)/n){
 #      [$1.delete('%')].pack('H*')
 #           }
 #   end



post '/videos/:id' do
# binding.pry
q = "UPDATE video SET name='#{params['name']}' ,title='#{params['title']}' , description='#{params['description']}', url='#{params['url'].gsub("watch?v=", "embed/")}' , genre='#{params['genre']}' WHERE id=#{params[:id]} "
  @videos = run_sql(q)
  redirect to('/videos')
end


post '/videos/:id/delete' do
  q = "DELETE FROM video WHERE id=#{params[:id]}"
  run_sql(q)
  redirect to('/videos')

end



get '/videos/:id/edit' do
  q = "SELECT * from  video WHERE id=#{params[:id]}"
  edit_rows = run_sql(q)
  @video = edit_rows.first #do this step because you only have one uniqe id

 erb :new
end


get '/videos' do
  q = "SELECT * FROM video ORDER BY id DESC"
  @videos = run_sql(q)

  erb :videos
end


get '/videos/genre/:genre' do
  q = "SELECT * FROM video WHERE genre='#{params[:genre]}'"
  @videos = run_sql(q)

  erb :videos
end


def run_sql(query)
  conn = PG.connect(:dbname => 'video_db', :host => 'localhost')
  result = conn.exec(query)
  conn.close
  result
end