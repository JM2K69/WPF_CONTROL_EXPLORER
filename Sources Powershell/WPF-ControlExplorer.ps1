##########################################################################
## WPF CONTROL EXPLORER                                                 ##
## v1.2                                                                 ##
## Author:Trevor Jones /  JM2K69                                        ##
## Released: 26-Sep-2016                                                ##
## Update: 16-Juil-2020                                                 ##
## More Info: http://smsagent.wordpress.com/tools/wpf-control-explorer/ ##
##########################################################################

<#
.Synopsis
   Exposes the properties, methods and events of the built-in WPF controls commonly used in WPF Windows desktop applications
.Notes
   Do not run from an existing PowerShell console session as the script will close it.  Right-click the script and run with PowerShell.
#>

#region UserInterface
# Load Assemblies
Add-Type -AssemblyName System.Windows.Forms | Out-Null
[void][System.Windows.Forms.Application]::EnableVisualStyles()
[Void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 

foreach ($item in $(gci -Filter *.dll).name) {
    [Void][System.Reflection.Assembly]::LoadFrom("$item")
}

# Define XAML code
[xml]$xaml = @"
<Controls:MetroWindow xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:Controls="clr-namespace:MahApps.Metro.Controls;assembly=MahApps.Metro"
        xmlns:iconPacks="http://metro.mahapps.com/winfx/xaml/iconpacks"
        xmlns:mbar="clr-namespace:AlertBarWpf;assembly=AlertBarWpf"
        WindowStartupLocation="CenterScreen"
        Title="WPF Control Explorer 1.2" Height="660" Width="950">
        
    <Window.Resources>
        <ResourceDictionary>
            <ResourceDictionary.MergedDictionaries>
                <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Controls.xaml" />
                <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Fonts.xaml" />
                <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Themes/Light.Blue.xaml" />
			</ResourceDictionary.MergedDictionaries>
		</ResourceDictionary>
    </Window.Resources>
    
    <Controls:MetroWindow.LeftWindowCommands>
        <Controls:WindowCommands>						
            <Button>
                <StackPanel Orientation="Horizontal">
                    <iconPacks:PackIconFontAwesome Kind="SearchenginBrands" />
                </StackPanel>
            </Button>
        </Controls:WindowCommands>
    </Controls:MetroWindow.LeftWindowCommands>
    <Controls:MetroWindow.RightWindowCommands>
        <Controls:WindowCommands>
			<StackPanel Orientation="Horizontal">					
			<Button Name="Theme" ToolTip="Switch Theme" Margin="-5 0 0 0">
                <StackPanel Orientation="Horizontal">
					<iconPacks:PackIconFontAwesome Kind="SyncSolid" />
                </StackPanel>
            </Button>
            <Button Name="BaseColor" ToolTip="Switch BaseColor" Margin="-5 0 0 0">
            <StackPanel Orientation="Horizontal">
                    <iconPacks:PackIconFontAwesome Kind="RandomSolid" />
            </StackPanel>
        </Button>

		</StackPanel>
        </Controls:WindowCommands>
    </Controls:MetroWindow.RightWindowCommands>
    
    <Grid>
      <StackPanel Orientation="Vertical" VerticalAlignment="Top">
        <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" Margin="0 5 0 0">
           <GroupBox x:Name="groupBox" Header="Controls" HorizontalAlignment="Left" VerticalAlignment="Top" Height="120" Width="450" Margin="0 0 5 0">
           <Grid Margin="10">
              <StackPanel Orientation="Horizontal" Margin="0 0 0 5">
                <Label x:Name="label" Content="Control" HorizontalAlignment="Left" VerticalAlignment="Top" FontSize="18"/>
                <ComboBox x:Name="CB_Control" HorizontalAlignment="Left" Margin="10,0,0,0" VerticalAlignment="Top" Width="325" Height="34" FontSize="18"/>
              </StackPanel>
              <StackPanel Orientation="Horizontal" Margin="0 35 0 5">
                 <Label x:Name="label_Copy" Content=".Net Class" HorizontalAlignment="Left" VerticalAlignment="Top" FontSize="14"/>
                 <TextBlock x:Name="TB_Class" HorizontalAlignment="Left" Margin="10 5 0 0" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="322" Height="22" FontSize="14"/>
              </StackPanel>
          </Grid>
         </GroupBox>
           <GroupBox x:Name="groupBox1" Header="Member" HorizontalAlignment="Left" Margin="0,0,0,0" VerticalAlignment="Top" Height="120" Width="450">
          <Grid Margin="7">
            <StackPanel Orientation="Horizontal">
               <Label x:Name="label_Copy1" Content="Member" HorizontalAlignment="Left" Margin="10,0,0,0" VerticalAlignment="Top" FontSize="18"/>
               <ComboBox x:Name="CB_Member" HorizontalAlignment="Left" Margin="10,0,0,0" VerticalAlignment="Top" Width="325" Height="34" FontSize="18"/>
            </StackPanel>
             <StackPanel Orientation="Horizontal">
                <Label x:Name="label_Copy2" Content="Count" HorizontalAlignment="Left" Margin="10,35,0,0" VerticalAlignment="Top" FontSize="14"/>
                <TextBlock x:Name="TB_MemberCount" HorizontalAlignment="Left" Margin="40,40,0,0" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="322" Height="22" FontSize="14"/>
             </StackPanel>
        </Grid>
        </GroupBox>
        </StackPanel>   
              <GroupBox x:Name="GB_Filters" Header="Filters" HorizontalAlignment="Center" Margin="0,5,0,0" VerticalAlignment="Top" Height="90" Width="905">
                <StackPanel Orientation="Horizontal" Margin="5" VerticalAlignment="Center" HorizontalAlignment="Center">  
                  <StackPanel x:Name="SP_Methods" Orientation="Horizontal" HorizontalAlignment="Center" IsEnabled="False">
                       <Label x:Name="label1" Content="Methods:" HorizontalAlignment="Left" Margin="10,0,10,0" VerticalAlignment="Top"/>
                        <Label x:Name="label2" Content="All"/>
                        <CheckBox x:Name="CB_all" VerticalContentAlignment="Center"/>
                        <Label x:Name="label3" Content="add_"/>
                        <CheckBox x:Name="CB_add" VerticalContentAlignment="Center"/>
                        <Label x:Name="label4" Content="get_"/>
                        <CheckBox x:Name="CB_get" VerticalContentAlignment="Center"/>
                        <Label x:Name="label5" Content="remove_"/>
                        <CheckBox x:Name="CB_remove" VerticalContentAlignment="Center"/>
                        <Label x:Name="label6" Content="set_"/>
                        <CheckBox x:Name="CB_set" VerticalContentAlignment="Center"/>
                        <Label x:Name="label7" Content="No &#39;__&#39;"  />
                        <CheckBox x:Name="CB_NoUnderscore" VerticalContentAlignment="Center" Margin="0 0 10 0"/>
                  </StackPanel>
                    <StackPanel Orientation="Horizontal">
                      <TextBox x:Name="TB_Filter" HorizontalAlignment="Left"  Margin="0,0,0,0" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="422" VerticalContentAlignment="Center" FontSize="16"/>
                    </StackPanel>
                  </StackPanel>
              </GroupBox>
              
             <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" VerticalAlignment="Center">
              <Border  Margin="0,5,0,0" BorderBrush="{DynamicResource MahApps.Brushes.Accent}" BorderThickness="1" Width="455">
                <ListBox x:Name="LB_Member" HorizontalAlignment="Left" Height="380" Margin="5,0,0,0" VerticalAlignment="Top" Width="442" FontSize="18"/>
              </Border>
               <StackPanel Orientation="Vertical">
                   <GroupBox x:Name="groupBox3" Header="Definition" HorizontalAlignment="Left" Margin="7,5,0,0" VerticalAlignment="Top" Height="90" Width="444">
                      <ScrollViewer VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Disabled">
                        <TextBox x:Name="TB_Definition" TextWrapping="Wrap" BorderThickness="0" IsReadOnly="True" Margin="10" />
                     </ScrollViewer>
                   </GroupBox>
                 <GroupBox x:Name="groupBox4" Header="Static Properties" HorizontalAlignment="Left" Margin="7,10,0,0" VerticalAlignment="Top" Height="90" Width="444">
                  <ScrollViewer VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Disabled">
                       <ListBox x:Name="LB_Static" BorderThickness="0" />
                 </ScrollViewer>
            </GroupBox>
                 <GroupBox x:Name="groupBox5" Header="Options" HorizontalAlignment="Left" Margin="7,10,0,0" VerticalAlignment="Top" Height="200" Width="444">
                   <StackPanel Orientation="Vertical">
                   <mbar:AlertBarWpf x:Name="msgbar" />
                     <TextBox TextWrapping="Wrap" BorderThickness="0" IsReadOnly="True" Margin="10"
                    Text="By default this WPF application load all the WPF control present in the PresentationFramework library contain in .NET"/>
                    <Controls:ToggleSwitch x:Name="Type" FontWeight="Thin"
                    Margin="10 0 0 0"
                    OffContent="Default PresentationFramework"
                    OnContent="Custom library"/>
                        <StackPanel x:Name="ST_File" Orientation="Horizontal" Visibility="Hidden">
                            <Label Content="Library:" HorizontalAlignment="Left" Margin="5,0,0,0" VerticalAlignment="Top" FontSize="14"/>
                            <Label x:Name="LB_File" Content="" HorizontalAlignment="Left" Margin="5,0,0,0" VerticalAlignment="Top" FontSize="14"/>
                        </StackPanel>
                        <StackPanel x:Name="ST_FileV" Orientation="Horizontal" Visibility="Hidden">
                            <Label Content="Version:" HorizontalAlignment="Left" Margin="5,0,0,0" VerticalAlignment="Top" FontSize="14"/>
                            <Label x:Name="LB_FileV" Content="" HorizontalAlignment="Left" Margin="5,0,0,0" VerticalAlignment="Top" FontSize="14"/>
                        </StackPanel>
                   </StackPanel>
                </GroupBox>
               </StackPanel>
             </StackPanel>

      </StackPanel>
    </Grid>
</Controls:MetroWindow>
"@

# Load XAML elements into a hash table
$script:hash = [hashtable]::Synchronized(@{})
$hash.Window = [Windows.Markup.XamlReader]::Load((New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $xaml))
$xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object -Process {
    $hash.$($_.Name) = $hash.Window.FindName($_.Name)
}
#endregion


$openfiledialog1 = New-Object 'System.Windows.Forms.OpenFileDialog'
$openfiledialog1.DefaultExt = "dll"
$openfiledialog1.Filter = "Applications (*.dll) |*.dll"
$openfiledialog1.ShowHelp = $True
$openfiledialog1.filename = "Search .NET Library"
$openfiledialog1.title = "Select an library"


#region PopulateInitialData
# Define the list of controls
$Controls = @(
"Border",
"Button",
"Calendar",
"Canvas",
"CheckBox",
"ComboBox",
"ContentControl",
"DataGrid",
"DatePicker",
"DockPanel",
"DocumentViewer",
"Ellipse",
"Expander",
"Grid",
"GridSplitter",
"GroupBox",
"Image",
"Label",
"ListBox",
"ListView",
"MediaElement",
"Menu",
"NavigationWindow",
"PasswordBox",
"ProgressBar",
"RadioButton",
"Rectangle",
"RichTextBox",
"ScrollBar",
"ScrollViewer",
"Separator",
"Slider",
"StackPanel",
"StatusBar",
"TabControl",
"TextBlock",
"TextBox",
"ToolBar",
"ToolBarPanel",
"ToolBarTray",
"TreeView",
"ViewBox",
"WebBrowser",
"Window",
"WrapPanel"
)

# Define the list of member types
$Members = @("Property","Method","Event")

# Load the .Net type names in the current domain and filter for controls in the WPF
$ControlTypes = [AppDomain]::CurrentDomain.GetAssemblies() | foreach {$_.GetTypes()} | where {$_.Name -in $Controls -and $_.Module -match "PresentationFramework.dll"}| Select Name,FullName

# Populate the combo boxes with controls and member types
$Hash.CB_Control.ItemsSource = [array]$Controls
$Hash.CB_Member.ItemsSource = [array]$Members
#endregion



#region Event Handling
# When selection changed on the Control combobox
$Hash.CB_Control.Add_SelectionChanged({
    # Blank everything
    $Hash.CB_Member.SelectedValue = ''
    $Hash.LB_Member.ItemsSource = ''
    $Hash.TB_Definition.Text = ''
    $Hash.LB_Static.ItemsSource = ''
    $Hash.TB_Filter.Text = ''
    $Hash.TB_MemberCount.Text  = ''
    $Script:ControlsSelected = $This.SelectedItem
    # Populate the .Net class textblock
    $DotNetClass = $ControlTypes | Where {$_.Name -eq $This.SelectedItem} | Select -ExpandProperty FullName
    $Hash.TB_Class.Text = $DotNetClass
    $hash.CB_Member.SelectedIndex = 0

    
})

# When selection changed on the Member combobox
$Hash.CB_Member.Add_SelectionChanged({
    $Hash.TB_Filter.Text = ''
        If ($This.SelectedItem -eq "Method")
        {
            $Hash.SP_Methods.IsEnabled = $True
            $Hash.CB_all.IsChecked = $True
        }
        Else
        {
            $Hash.SP_Methods.IsEnabled = $False
            $hash.CB_all.IsChecked = $False
        }
        # Make sure the checkboxes are not checked
        $Hash.CB_add.IsChecked = $False
        $Hash.CB_remove.IsChecked = $False
        $Hash.CB_set.IsChecked = $False
        $Hash.CB_NoUnderscore.IsChecked = $False
        $Hash.CB_get.IsChecked = $False


        if ($hash.Type.IsOn -eq $True){


    	    if( $null -eq $Assembly_Infos){

                $Assembly_Infos = [System.Reflection.Assembly]::LoadFrom("$($openfiledialog1.FileName)")}
                else{}

       $SControls = $Assembly_Infos.GetModules().gettypes()|Where-Object{$_.Name.equals("$Script:ControlsSelected")}
       $Hash.TB_Class.Text = $SControls
       #$SMembers = 
       $Script:SMembers = $SControls  | Get-Member -MemberType $This.SelectedItem -Force | Select Name,Definition
       if ($null -eq $Script:SMembers){
        $Script:SMembers = $SControls.GetMembers() | where { $_.MemberType -like "$($This.SelectedItem)"} | Select-Object Name
       }
       $Script:Methods = [array]$SMembers
       $Hash.LB_Member.ItemsSource = [array]$Script:SMembers.Name
       $Hash.TB_MemberCount.Text = $Script:SMembers.Count

       
    }

    
    else {

    # Only run if something has been selected
    If ($This.SelectedIndex -ne "-1")
    {
        # Create a control of the selected type
        $ControlType = $ControlTypes | Where {$_.Name -eq $hash.CB_Control.SelectedItem}
        $Control = New-Object ($ControlType.FullName)
        # Find and populate the members of the selected member type
        $script:Members = $Control | Get-Member -MemberType $This.SelectedItem -Force | Select Name,Definition
        $Hash.LB_Member.ItemsSource = [array]$script:Members.Name
        $Hash.TB_MemberCount.Text = $Members.Count
        
        # If 'method', enable the methods stackpanel in the filter section
        If ($This.SelectedItem -eq "Method")
        {
            $Hash.SP_Methods.IsEnabled = $True
            $Hash.CB_all.IsChecked = $True
        }
        Else
        {
            $Hash.SP_Methods.IsEnabled = $False
            $hash.CB_all.IsChecked = $False
        }
        # Make sure the checkboxes are not checked
        $Hash.CB_add.IsChecked = $False
        $Hash.CB_remove.IsChecked = $False
        $Hash.CB_set.IsChecked = $False
        $Hash.CB_NoUnderscore.IsChecked = $False
        $Hash.CB_get.IsChecked = $False
    }
    }
})

# When selection changed on Member listbox
$Hash.LB_Member.Add_SelectionChanged({
     if ($hash.Type.IsOn -eq $True){
        $Definition = $Script:SMembers | where {$_.Name -eq  $This.SelectedItem} | Select -ExpandProperty Definition
        $Hash.TB_Definition.Text = $Definition

        }
    else {


    # Find the definition and populate the definition textbox
    $Definition = $Members | where {$_.Name -eq  $This.SelectedItem} | Select -ExpandProperty Definition
    $Hash.TB_Definition.Text = $Definition
    # If 'property', we need to get the static members also, where available
    If ($Hash.CB_Member.SelectedItem -eq "Property")
    {
        $script:StaticMembers = ''
        # Only run if the definition contains something in the System namespace
        If ($Definition -match 'System.')
        {
            $ClassName = $Definition.Split(' ')[0]
            try
            {
                # Get the list of static member names
                $script:StaticMembers = New-Object -TypeName $ClassName -ErrorAction Stop | Get-Member -Static -MemberType Property -ErrorAction Stop | Select -ExpandProperty Name
            }
            catch
            { 
                $Hash.LB_Static.ItemsSource = ""
            }
            if ($StaticMembers -ne "Empty")
            {
                # Populate the static list box with the static members
                $Hash.LB_Static.ItemsSource = [array]$StaticMembers
            }
        }
        Else
        {
            $Hash.LB_Static.ItemsSource = ""
        }
    }
    Else
    {
        $Hash.LB_Static.ItemsSource = ""
    }
    }
})

# When the filter textbox is used
$Hash.TB_Filter.Add_TextChanged({
    [System.Windows.Data.CollectionViewSource]::GetDefaultView($Hash.LB_Member.ItemsSource).Filter = [Predicate[Object]]{             
        Try {
            $args[0] -match [regex]::Escape($This.Text)
        } Catch {
            $True
        }
    } 
})

#region Checkbox event handling
# If checkbox checked, uncheck the other checkboxes, and populate the member list box based on the checkbox selections
$Hash.CB_all.Add_Checked({
    $hash.CB_add.IsChecked = $False
    $Hash.CB_remove.IsChecked = $False
    $Hash.CB_set.IsChecked = $False
    $Hash.CB_NoUnderscore.IsChecked = $False
    $Hash.CB_get.IsChecked = $False
    $Hash.TB_Filter.Text = ''

    $Hash.LB_Member.ItemsSource = [array]$Members.Name
})

$Hash.CB_add.Add_Checked({
    
     if ($hash.Type.IsOn -eq $True){
        $Members = $Script:Methods 
        }
    
    $hash.CB_all.IsChecked = $False
    $Hash.CB_remove.IsChecked = $False
    $Hash.CB_set.IsChecked = $False
    $Hash.CB_NoUnderscore.IsChecked = $False
    $Hash.CB_get.IsChecked = $False
    $Hash.TB_Filter.Text = ''

    $Hash.LB_Member.ItemsSource = [array]($Members | where {$_ -match "add_"} | Select -ExpandProperty Name)
})

$Hash.CB_get.Add_Checked({
     if ($hash.Type.IsOn -eq $True){
        $Members = $Script:Methods 
        }

    $hash.CB_all.IsChecked = $False
    $Hash.CB_remove.IsChecked = $False
    $Hash.CB_set.IsChecked = $Falsez
    $Hash.CB_NoUnderscore.IsChecked = $False
    $Hash.CB_add.IsChecked = $False
    $Hash.TB_Filter.Text = ''

    $Hash.LB_Member.ItemsSource = [array]($Members | where {$_ -match "get_"} | Select -ExpandProperty Name) 
})

$Hash.CB_remove.Add_Checked({
    
    if ($hash.Type.IsOn -eq $True){
        $Members = $Script:Methods 
        }

    $hash.CB_all.IsChecked = $False
    $Hash.CB_get.IsChecked = $False
    $Hash.CB_set.IsChecked = $False
    $Hash.CB_NoUnderscore.IsChecked = $False
    $Hash.CB_add.IsChecked = $False
    $Hash.TB_Filter.Text = ''

    $Hash.LB_Member.ItemsSource = [array]($Members | where {$_ -match "remove_"} | Select -ExpandProperty Name)
})

$Hash.CB_set.Add_Checked({
     if ($hash.Type.IsOn -eq $True){
        $Members = $Script:Methods 
        }

    $hash.CB_all.IsChecked = $False
    $Hash.CB_get.IsChecked = $False
    $Hash.CB_remove.IsChecked = $False
    $Hash.CB_NoUnderscore.IsChecked = $False
    $Hash.CB_add.IsChecked = $False
    $Hash.TB_Filter.Text = ''

    $Hash.LB_Member.ItemsSource = [array]($Members | where {$_ -match "set_"} | Select -ExpandProperty Name)
})

$Hash.CB_NoUnderscore.Add_Checked({
     if ($hash.Type.IsOn -eq $True){
        $Members = $Script:Methods 
        }

    $hash.CB_all.IsChecked = $False
    $Hash.CB_get.IsChecked = $False
    $Hash.CB_remove.IsChecked = $False
    $Hash.CB_set.IsChecked = $False
    $Hash.CB_add.IsChecked = $False
    $Hash.TB_Filter.Text = ''

    $Hash.LB_Member.ItemsSource = [array]($Members | where {$_ -notmatch "_"} | Select -ExpandProperty Name)
})

# Create Unchecked events to restore all results if a checkbox gets unchecked, and clear the text filter
$hash.CB_NoUnderscore,$Hash.CB_get,$Hash.CB_remove,$Hash.CB_set,$Hash.CB_add | foreach {
    $_.Add_UnChecked({
        If ($hash.CB_NoUnderscore.IsChecked -ne $True -and $hash.CB_get.IsChecked -ne $True -and $hash.CB_remove.IsChecked -ne $True -and $hash.CB_set.IsChecked -ne $True -and $hash.CB_add.IsChecked -ne $True)
        {
            $Hash.CB_all.IsChecked = $True
            $Hash.TB_Filter.Text = ''
        }
    })
}
#endregion
#endregion

$hash.Type.Add_Toggled({

if ($hash.Type.IsOn -eq $True){

      $Hash.CB_Control.Clear();
      $Hash.CB_Control.Text = ""; 
      $Hash.CB_Control.ItemsSource = $null

      If($openfiledialog1.ShowDialog() -eq 'OK')
		{	
			$Assembly_Infos = [System.Reflection.Assembly]::LoadFrom("$($openfiledialog1.FileName)")
            $File =  $openfiledialog1.SafeFileName
            $FileVersion=[System.Diagnostics.FileVersionInfo]::GetVersionInfo("$File").FileVersion
            $SControls = $Assembly_Infos.GetModules().gettypes()|Where-Object { $_.BaseType -like "System.Windows.Controls.Control*" } | Select Name
            
            $Hash.ST_File.Visibility = "Visible"
            $Hash.ST_FileV.Visibility = "Visible"
            $Hash.LB_File.Content = $File
            $Hash.LB_FileV.Content = $FileVersion
            $Hash.CB_Control.ItemsSource =[array]$SControls.Name
            $Hash.msgbar.Clear();	
            $Hash.msgbar.IconVisibility=$true
            $Hash.msgbar.SetSuccessAlert("The Assembly $File is succeffully load ", 3);	
            $hash.CB_Control.SelectedIndex = 0
            $hash.CB_Member.SelectedIndex = 0
	
        
		}	


}
else{
          $Hash.CB_Control.ItemsSource = [array]$Controls 
          $Hash.ST_File.Visibility = "Hidden"
          $Hash.ST_FileV.Visibility = "Hidden"
          $hash.CB_Control.SelectedIndex = 0
          $hash.CB_Member.SelectedIndex = 0

    
}

})
$Hash.Theme.Add_Click({
    $Theme1 = [ControlzEx.Theming.ThemeManager]::Current.DetectTheme($Hash.Window)
    Write-Host $themeS
     $my_theme = ($Theme1.BaseColorScheme)
     If($my_theme -eq "Light")
         {
             [ControlzEx.Theming.ThemeManager]::Current.ChangeThemeBaseColor($Hash.Window,"Dark")
 
         }
     ElseIf($my_theme -eq "Dark")
         {					
             [ControlzEx.Theming.ThemeManager]::Current.ChangeThemeBaseColor($Hash.Window,"Light")
 
         }		
 })

 $Hash.BaseColor.Add_Click({

    $Script:Colors=@()
    $Accent = [ControlzEx.Theming.ThemeManager]::Current.ColorSchemes
    foreach ($item in $Accent)
    {
        $Script:Colors += $item
    }

    $Value = $Script:Colors[$(Get-Random -Minimum 0 -Maximum 23)]
    [ControlzEx.Theming.ThemeManager]::Current.ChangeThemeColorScheme($Hash.Window ,$Value)

})
$hash.CB_Control.SelectedIndex = 0
$hash.CB_Member.SelectedIndex = 0



#region Display the UI
# Display Window
# If code is running in ISE, use ShowDialog()...
if ($psISE)
{
    $null = $Hash.window.Dispatcher.InvokeAsync{$Hash.Window.ShowDialog()}.Wait()
}
# ...otherwise run as an application
Else
{
    # Make PowerShell Disappear
    $windowcode = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
    $asyncwindow = Add-Type -MemberDefinition $windowcode -Name Win32ShowWindowAsync -Namespace Win32Functions -PassThru
    $null = $asyncwindow::ShowWindowAsync((Get-Process -PID $pid).MainWindowHandle, 0)
 
    $app = New-Object -TypeName Windows.Application
    $app.Run($Hash.Window)
}
#endregion

