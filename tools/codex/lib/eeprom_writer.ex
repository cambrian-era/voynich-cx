defmodule Codex.EEPROMWriter do
  use Firmata.Protocol.Mixin
  use GenServer
  require Logger

  def start_link(port) do
    GenServer.start_link(__MODULE__, port)
  end

  def init(port) do
    Logger.info "Connecting to Firmata on port: #{inspect port}"
    { :ok, firmata } = Firmata.Board.start_link(port, [], :hardware_interface)
    Logger.info "Initializing Firmata: #{inspect firmata}"
    Firmata.Board.sysex_write(firmata, @firmware_query, <<>>)
    { :ok, firmata }
  end

  def init_i2c do
  end
end