class VMServer

  attr_accessor :vm_user, :vm_password, :guest_user, :guest_password, :datastore, :host, :url

  def initialize
    yield self if block_given?
    # This is the base command used for all the commands.
    @base_command       = "vmrun -T server -h #{host} -u #{vm_user} -p #{@vm_password}"
    @base_path_in_host  = '/home/sriram/Projects/Behaviour Analysis/'
    @base_path_in_guest = 'C:\Documents and Settings\Administrator\Desktop\analysis'

    files = ['ie.bat', 'systemsherlock.exe', 'compare.bat', 'ignore.txt']
    # @files is an array of hashes storing the file and its corresponding host and guest paths.
    @files = []

    files.each do |file|
      @files << {:file => file, :host_path => File.join(@base_path_in_host, file),
                 :guest_path => "#{@base_path_in_guest}\\#{file}"}
    end

  end


  def log(msg)
    puts "#{Time.now} #{msg}"
  end


  # Check if a file exists
  def file_exists_in_guest?(file)
    vm_command = "#{@base_command} -gu #{guest_user} -gp #{guest_password} fileExistsInGuest \'#{datastore}\' #{file}"
    output = system(vm_command)
    if output =~ /The file exists/
      return true
    else
      return false
    end
  end


  def execute_command(command,args={})
    vm_command = ""

    case command
      when "start"
        vm_command = "#{@base_command} #{command} \'#{@datastore}\'"
        log vm_command

      when "createDirectoryInGuest"
        dir = args[:dir]
        vm_command = "#{@base_command} -gu #{@guest_user} -gp #{@guest_password} #{command} \'#{@datastore}\' \'#{dir}\'"
        log vm_command

      when "copyFileFromHostToGuest"
        src  = args[:src]
        dest = args[:dest]
        vm_command = "#{@base_command} -gu #{@guest_user} -gp #{@guest_password} #{command} \'#{@datastore}\' \'#{src}\' \'#{dest}\'"
        log vm_command

      when "listProcessesInGuest"
        processes = `#{@base_command} -gu #{@guest_user} -gp #{guest_password} #{command} \'#{@datastore}\'`
        return processes

      when "runProgramInGuest"
        program   = args[:program]
        prog_args = args[:prog_args]

        vm_command = "#{@base_command} -gu #{@guest_user} -gp #{@guest_password} #{command} \'#{@datastore}\' -activeWindow #{program} #{prog_args}"
        log vm_command

      when "killProcessInGuest"
        pid = args[:pid]
        vm_command = "#{@base_command} -gu #{@guest_user} -gp #{guest_password} #{command} \'#{@datastore}\' #{pid}"
        log vm_command

      when "copyFileFromGuestToHost"
        src  = args[:src]
        dest = args[:dest]

        vm_command = "#{@base_command} -gu #{@guest_user} -gp #{@guest_password} #{command} \'#{@datastore}\' \'#{src}\' \'#{dest}\'"
        log vm_command
    end

    output = system(vm_command)
    log("#{vm_command} has been executed. #{output}")
    output
  end
end


analyze = BehaviourAnalysis.new do |ba|
#  ba.host             = 'http://localhost:8222/sdk'
  ba.host             = 'https://10.0.2.19:8333/sdk'
  ba.vm_user          = 'root'
  ba.vm_password      = 'prashant'
  ba.guest_password   = 'prashant'
  ba.guest_user       = 'administrator'
#  ba.datastore        = '[standard] Windows xp/Windows xp.vmx'
  ba.datastore        = '[standard] winxp/winxp.vmx'
  ba.url              = 'www.yahoo.com'
end

