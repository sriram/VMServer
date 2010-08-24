class VMServer

  attr_accessor :vm_user, :vm_password, :guest_user, :guest_password, :datastore, :host, :url, :logging_enabled

  def initialize
    yield self if block_given?
    # This is the base command used for all the commands.
    @base_command       = "vmrun -T server -h #{@host} -u #{@vm_user} -p #{@vm_password}"
  end

  ##
  # Logs if logging is enabled

  def log(msg)
    puts "#{Time.now} #{msg}" if @logging_enabled
  end


  ##
  # Checks if a file exists in the guest OS

  def file_exists_in_guest?(file)
    vm_command = "#{@base_command} -gu #{guest_user} -gp #{guest_password} fileExistsInGuest \'#{datastore}\' #{file}"
    output = system(vm_command)
    if output =~ /The file exists/
      return true
    else
      return false
    end
  end


  ##
  # Start up the Virtual Machine

  def vm_start
    vm_command = "#{@base_command} #{command} \'#{@datastore}\'"
    log vm_command
    result = system(vm_command)
    result  ? log("VM started successfully has been executed.") : log("Error! VM could not be started.")
    result
  end


  ##
  #  Create a directory in the Virtual Machine

  def vm_mkdir(dir)
    vm_command = "#{@base_command} -gu #{@guest_user} -gp #{@guest_password} #{command} \'#{@datastore}\' \'#{dir}\'"
    log vm_command
    result = system(vm_command)
    result  ? log("Directory created successfully in guest.") : log("Error! Directory could not be created.")
    result
  end


##
# Copy a file from host OS to Guest OS

  def copy_file_from_host_to_guest(src, dest)
    vm_command = "#{@base_command} -gu #{@guest_user} -gp #{@guest_password} #{command} \'#{@datastore}\' \'#{src}\' \'#{dest}\'"
    log vm_command
    result = system(vm_command)
    result ? log("Copy successful.") : log("Error! Copy failed.")
    result
  end


  ##
  # Copy a file from Guest OS to Host OS

  def copy_from_guest_to_host(src,dest)
    vm_command = "#{@base_command} -gu #{@guest_user} -gp #{@guest_password} #{command} \'#{@datastore}\' \'#{src}\' \'#{dest}\'"
    log vm_command
    result = system(vm_command)
    result ? log("Copy successful.") : log("Error! Copy failed.")
    result
  end


  ##
  # Get a list of processes running in the Guest OS

  def get_processes_in_guest
    processes = `#{@base_command} -gu #{@guest_user} -gp #{guest_password} #{command} \'#{@datastore}\'`
    processes
  end


  ##
  # Execute a program in the Guest OS

  def run_program_in_guest(program,prog_args={})
    prog_args = prog_args[:prog_args]
    vm_command = "#{@base_command} -gu #{@guest_user} -gp #{@guest_password} #{command} \'#{@datastore}\' -activeWindow #{program} #{prog_args}"
    log vm_command
    result = system(vm_command)
    result ? log("Program executed successfully in guest.") : log("Error! Failed to execute program in guest.")
    result
  end


  ##
  # Kill a process with the given PID in the Guest OS

  def kill_process_in_guest(pid)
    vm_command = "#{@base_command} -gu #{@guest_user} -gp #{guest_password} #{command} \'#{@datastore}\' #{pid}"
    log vm_command
    result = system(vm_command)
    result ? log("Program executed successfully in guest.") : log("Error! Failed to execute program in guest.")
    result
  end

end



