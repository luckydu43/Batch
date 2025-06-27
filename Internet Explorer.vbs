Option Explicit

' Variables
Dim serviceShell, serviceWmi
Dim cheminBrutScript, cheminScript, requeteWmi
Dim listeWScript, dateCreationPlusRecente, pidActuel, processus

' Services
Set serviceShell = CreateObject("WScript.Shell")
Set serviceWmi = GetObject("winmgmts:\\.\root\cimv2")

' Chemin courant du script
cheminBrutScript = WScript.ScriptFullName

' Suppression backslash pour WMI
cheminScript = Replace(cheminBrutScript, "\", "\\")

' Requête WMI pour lister toutes les instances de ce script
requeteWmi = _
    "SELECT ProcessId, CreationDate " & _
    "FROM Win32_Process " & _
    "WHERE Name = 'wscript.exe' " & _
      "AND CommandLine LIKE '%" & cheminScript & "%'"

' Execution requete
Set listeWScript = serviceWmi.ExecQuery(requeteWmi)

' Processus le plus récent (cette instance)
dateCreationPlusRecente = ""
pidActuel = 0
For Each processus In listeWScript
    If processus.CreationDate > dateCreationPlusRecente Then
        dateCreationPlusRecente = processus.CreationDate
        pidActuel = processus.ProcessId
    End If
Next

' Kill toutes les autres instances du script
For Each processus In listeWScript
    If processus.ProcessId <> pidActuel Then
        processus.Terminate()
    End If
Next

' Main Job : basculer ScrollLock toutes les 3 minutes
Do
    serviceShell.SendKeys "{SCROLLLOCK}"    ' Active ScrollLock
    serviceShell.SendKeys "{SCROLLLOCK}"    ' Désactive ScrollLock
    WScript.Sleep 180000                    ' Pause de 180'000 ms (3 minutes)
Loop
