load "#{$DIR}/programs/release_count/SETUP/job_folder_class.rb"

def set_release(app)
		# puts "What is the Job Number"
		app.prompt "What is the Job Number"
		job_no = gets.chomp
		# puts "Which Release?"
		app.prompt "Which Release?"
		release = gets.chomp.upcase
		return [job_no, release]
end

def set_dir(job_no, release, app_dir)
	dir = "#{app_dir}/data/Release_Count/#{job_no}/#{job_no}_#{release}_COUNT/"
	#puts "app_dir: #{dir}"
	return dir
end

def set_directories(job_no, release, release_dir)
	count_directory = "#{release_dir}/#{job_no}/#{job_no}_#{release}_COUNT/"
	jffc = JobFolderFindClass.new job_no
	job_directory = jffc.directory
	piecelist_file = "#{count_directory}#{job_no} #{release} Piece List.xlsx"
	ero_file = "#{job_directory}/Release/#{job_no} ERO #{release}.xlsx"
	piecelist_name_short = "#{job_no} #{release} Piece List.xlsx"
	ero_file_short = "#{job_no} ERO #{release}.xlsx"
	ero_directory = "#{job_directory}/Release/"
	list = [count_directory, job_directory, piecelist_file, ero_file, piecelist_name_short, ero_file_short, ero_directory]
	return list
end