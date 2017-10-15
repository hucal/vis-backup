local module = {}


-- Return the backup path concatenated with the filename, replace / with %
module.entire_path = function(backup_dir, path)
  return backup_dir .. "/" .. string.gsub(path, "/", "%%")
end


-- Return the backup path concatenated with the filename, replace / with %
-- and append the current time using time_format
module.entire_path_with_timestamp = function(backup_dir, path)
  return backup_dir .. "/" .. os.date(module.time_format) .. string.gsub(path, "/", "%%")
end


-- Before saving the file, copy the current contents of the file to a backup file
vis.events.subscribe(vis.events.FILE_SAVE_PRE, function (file, path)
  local backup_path = module.get_fname(module.directory, path)
  
  local backup_file = io.open(backup_path, "w")
  local current_file = io.open(path)
  if backup_file == nil or current_file == nil then 
    return
  end

  for line in current_file:lines() do
    backup_file:write(line .. "\n")
  end
  
  backup_file:close()
end)


-- Set defaults
module.directory = string.format("%s/.vis-backups", os.getenv("HOME"))

module.get_fname = module.entire_path

module.time_format = "%H-%M-"


module.mkdir = true

if module.mkdir then
  os.execute("mkdir -p " .. module.directory)
end


return module