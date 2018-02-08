configure :test do
  set :database, {
    adapter: 'postgresql',
    encoding: 'utf8',
    database: 'firstbot_test',
    pool: 5,
    username: 'postgres',
    host: 'postgres'
  }
end

configure :development do
set :database, {
  adapter: 'postgresql',
  encoding: 'utf8',
  database: 'firstbot_development',
  pool: 5,
  username: 'postgres',
  host: 'postgres'
}
end

configure :production do
  set :database, {
    adapter: 'postgresql',
    encoding: 'utf8',
    database: 'firstbot_production',
    pool: 5,
    username: 'postgres',
    host: 'postgres'
  }
end