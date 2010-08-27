class VMServer

  attr_accessor :vm_user, :vm_password, :guest_user, :guest_password, :datastore, :host, :logging_enabled

  def initialize
    yield self
    raise ArgumentError,  "Please make sure you have set host ,vm_user and vm_password in the configuration!" unless @host || @vm_user || @vm_password
    # This is the base command used for all the commands.
    @base_command       = "vmrun -T server -h #{@host} -u #{@vm_user} -p #{@vm_password}"
  end


  ##
  # Logs if logging is enabled

  def log(msg)
    puts "#{Time.now} #{msg}" if @logging_enabled
  end


  # -------------------------------- Controlling Virtual Machine Power States with vmrun ------------------------- 
  #
  ##
  # Start up the Virtual Machine

  def start
    command    = 'start'
    vm_command = "#{@base_command} #{command} \'#{@datastore}\'"
    log vm_command
    result = system(vm_command)
    result  ? log("VM started successfully has been executed.") : log("Error! VM could not be started.")
    result
  end


  ##
  # Stops the Virtual Machine
  # Mode is soft by default.
  # If it is overridden to be 'hard' it acts in a similar fashion to that pf physically switching off a machine.

  def stop(mode='soft')
    command    = 'stop'
    vm_command = "#{@base_command} #{command} \'#{@datastore}\' #{mode}"
    log vm_command
    result = system(vm_command)
    result  ? log("VM stopped successfully.") : log("Error! VM could not be stopped.")
    result
  end


  ##
  # Reset the Virtual Machine
  # Mode is soft by default.
  # If it is overridden to be 'hard' it acts in a similar fashion to that pf physically switching off a machine.

  def reset(mode='soft')
    command    = 'reset'
    vm_command = "#{@base_command} #{command} \'#{@datastore}\' #{mode}"
    log vm_command
    result = system(vm_command)
    result  ? log("VM has been resetted.") : log("Error! VM could not be reset.")
    result
  end


  ##
  # Suspend the Virtual Machine
  # Mode is soft by default.
  # If it is overridden to be 'hard' it acts in a similar fashion to that pf physically switching off a machine.

  def suspend(mode='soft')
    command    = 'reset'
    vm_command = "#{@base_command} #{command} \'#{@datastore}\' #{mode}"
    log vm_command
    result = system(vm_command)
    result  ? log("VM has been suspended.") : log("Error! VM could not be suspended.")
    result
  end


  ##
  # Pause the Virtual Machine

  def pause
    command    = 'pause'
    vm_command = "#{@base_command} #{command} \'#{@datastore}\'"
    log vm_command
    result = system(vm_command)
    result  ? log("VM has been paused") : log("Error! VM could not be paused.")
    result
  end


  ##
  # Pause the Virtual Machine

  def unpause
    command    = 'unpause'
    vm_command = "#{@base_command} #{command} \'#{@datastore}\'"
    log vm_command
    result = system(vm_command)
    result  ? log("VM has been unpaused") : log("Error! VM could not be unpaused.")
    result
  end


  # -------------------------------------- VM Server Snapshots -------------------------------------------------

  ##
  # Take a snapshot of the Virtual Machine

  def snapshot(name="snapshot_#{Time.now.strftime("%m%d")}")
    command    = 'snapshot'
    vm_command = "#{@base_command} #{command} \'#{@datastore}\' #{name}"
    log vm_command
    result = system(vm_command)
    result  ? log("SnapShot successful") : log("Error! VM SnapShot failed.")
    result
  end


  ##
  # Revert to previous snapshot

  def revert_to_snapshot(name)
    command    = 'revertToSnapshot'
    vm_command = "#{@base_command} #{command} \'#{@datastore}\' #{name}"
    log vm_command
    result = system(vm_command)
    result  ? log("Revert SnapShot successful") : log("Error! VM Revert SnapShot failed.")
    result
  end


  ##
  # Delete snapshot of the Virtual Machine

  def delete_snapshot(name)
    command    = 'deleteSnapshot'
    vm_command = "#{@base_command} #{command} \'#{@datastore}\' #{name}"
    log vm_command
    result = system(vm_command)
    result  ? log("SnapShot deleted successful") : log("Error! VM SnapShot delete failed.")
    result
  end


  # -------------------------------------- Working with Files and Directory in Guest OS -------------------------
  #
  ##
  #  Create a directory in the Virtual Machine

  def mkdir(dir)
    command    = 'createDirectoryInGuest'
    vm_command = "#{@base_command} -gu #{@guest_user} -gp #{@guest_password} #{command} \'#{@datastore}\' \'#{dir}\'"
    log vm_command
    result = system(vm_command)
    result  ? log("Directory created successfully in guest.") : log("Error! Directory could not be created.")
    result
  end


  ##
  # Remove Directory form the Guest OS

  def rmdir(dir)
    command    = 'deleteDirectoryInGuest'
    vm_command = "#{@base_command} -gu #{@guest_user} -gp #{@guest_password} #{command} \'#{@datastore}\' \'#{dir}\'"
    log vm_command
    result = system(vm_command)
    result ? log("Directory deleted successfully.") : log("Error! Failed to delete directory.")
    result
  end


  ##
  # Remove Directory form the Guest OS

  def rmfile(file)
    command    = 'deleteFileInGuest'
    vm_command = "#{@base_command} -gu #{@guest_user} -gp #{@guest_password} #{command} \'#{@datastore}\' \'#{file}\'"
    log vm_command
    result = system(vm_command)
    result ? log("File deleted successfully.") : log("Error! Failed to delete file.")
    result
  end


  ##
  # List a directory in Guest OS

  def ls(dir)
    command    = 'listDirectoryInGuest'
#    vm_command = "#{@base_command} -gu #{@guest_user} -gp #{@guest_password} #{command} \'#{@datastore}\' \'#{dir}\'"
#    log vm_command
#    result = system(vm_command)
#    result ? log("Listing Successful.") : log("Error! Listing directory failed.")
#    result
    entries = `#{@base_command} -gu #{@guest_user} -gp #{@guest_password} #{command} \'#{@datastore}\' \'#{dir}\'`
    # The entries would be a list of entries searated by new line. Convert this to an array.
    entries = entries.split("\n")
    entries
  end


  ##
  # Checks if a file exists in the guest OS

  def file_exists_in_guest?(file)
    vm_command = "#{@base_command} -gu #{@guest_user} -gp #{@guest_password} fileExistsInGuest \'#{datastore}\' \'#{file}\'"
    output = system(vm_command)
    if output =~ /The file exists/
      return true
    else
      return false
    end
  end


  ##
  # Copy a file from host OS to Guest OS

  def copy_file_from_host_to_guest(src, dest)
    command    = 'copyFileFromHostToGuest'
    vm_command = "#{@base_command} -gu #{@guest_user} -gp #{@guest_password} #{command} \'#{@datastore}\' \'#{src}\' \'#{dest}\'"
    log vm_command
    result = system(vm_command)
    result ? log("Copy successful.") : log("Error! Copy failed.")
    result
  end


  ##
  # Copy a file from Guest OS to Host OS

  def copy_file_from_guest_to_host(src,dest)
    command    = 'copyFileFromGuestToHost'
    vm_command = "#{@base_command} -gu #{@guest_user} -gp #{@guest_password} #{command} \'#{@datastore}\' \'#{src}\' \'#{dest}\'"
    log vm_command
    result = system(vm_command)
    result ? log("Copy successful.") : log("Error! Copy failed.")
    result
  end


  ##
  # Get a list of processes running in the Guest OS

  def get_processes_in_guest
    command   = 'listProcessesInGuest'
    processes = `#{@base_command} -gu #{@guest_user} -gp #{guest_password} #{command} \'#{@datastore}\'`
    processes
  end


  ##
  # Execute a program in the Guest OS

  def run_program_in_guest(program,prog_args={})
    command    = 'runProgramInGuest'
    prog_args  = prog_args[:prog_args]
    vm_command = "#{@base_command} -gu #{@guest_user} -gp #{@guest_password} #{command} \'#{@datastore}\' -activeWindow \'#{program}\' #{prog_args}"
    log vm_command
    result = system(vm_command)
    result ? log("Program executed successfully in guest.") : log("Error! Failed to execute program in guest.")
    result
  end


  ##
  # Kill a process with the given PID in the Guest OS

  def kill_process_in_guest(pid)
    command    = 'killProcessInGuest'
    vm_command = "#{@base_command} -gu #{@guest_user} -gp #{guest_password} #{command} \'#{@datastore}\' #{pid}"
    log vm_command
    result = system(vm_command)
    result ? log("Program executed successfully in guest.") : log("Error! Failed to execute program in guest.")
    result
  end


  ##
  # Remove Directory form the Guest OS

  def capture_screen(output_file)
    command    = 'captureScreen'
    vm_command = "#{@base_command} -gu #{@guest_user} -gp #{@guest_password} #{command} \'#{@datastore}\' \'#{output_file}\'"
    log vm_command
    result = system(vm_command)
    result ? log("File deleted successfully.") : log("Error! Failed to delete file.")
    result
  end
end