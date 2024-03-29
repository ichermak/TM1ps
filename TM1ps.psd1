# ======================================================================================================
# _____  _      _   ___   __ 
#  | |  | |\/| / | | |_) ( (`
#  |_|  |_|  | |_| |_|   _)_)
# 
# ======================================================================================================

@{
    # RootModule = ''

    ModuleVersion = '0.0.1'

    # CompatiblePSEditions = @()

    GUID = '042f4656-e704-4e88-b0cb-a1832ec9f17c'

    Author = 'Ifthen CHERMAK'

    CompanyName = 'ichermak'

    Copyright = '(c) 2019 Ifthen CHERMAK. All rights reserved.'

    # Description = ''

    PowerShellVersion = '5.1.1'

    # PowerShellHostName = ''

    # PowerShellHostVersion = ''

    # DotNetFrameworkVersion = ''

    # CLRVersion = ''

    ProcessorArchitecture = 'None'

    # RequiredModules = @()

    # RequiredAssemblies = @('System.Net', 'System.Security')

    # ScriptsToProcess = @()

    # TypesToProcess = @('types.ps1xml')

    # FormatsToProcess = @(format.ps1xml)

    NestedModules = @(
                        'TM1ps_Common.psm1',
                        'TM1ps_Server.psm1',
                        'TM1ps_Application.psm1',
                        'TM1ps_Cube.psm1',
                        'TM1ps_View.psm1',
                        'TM1ps_Dimension.psm1',
                        'TM1ps_Hierarchy.psm1',
                        'TM1ps_Subset.psm1',
                        'TM1ps_Process.psm1',
                        'TM1ps_Chore.psm1'
                    )
    
    FunctionsToExport = @(
                            'Get-Tm1Servers',
                            'Request-Tm1Login',
                            'Request-Tm1Logout',
                            'Request-Tm1Rest',
                            'Invoke-Tm1ExcelStringReplace',
                            'Get-Tm1ServerConfiguration',
                            'Get-Tm1Applications',
                            'Test-Tm1Application',
                            'Get-Tm1Cubes',
                            'Test-Tm1Cube',
                            'Get-Tm1Views',
                            'Test-Tm1View',
                            'Invoke-Tm1ViewCreateByMdx',
                            'Get-Tm1Dimensions',
                            'Test-Tm1Dimension',
                            'Get-Tm1Hierarchies',
                            'Test-Tm1Hierarchy',
                            'Get-Tm1Subsets',
                            'Test-Tm1Subset',
                            'Invoke-Tm1SubsetCreatebyMDX',
                            'Get-Tm1Processes',
                            'Test-Tm1Process',
                            'Invoke-Tm1Process',
                            'Get-Tm1Chores',
                            'Test-Tm1Chore',
                            'Invoke-Tm1Chore'
                        )

    CmdletsToExport = @()

    VariablesToExport = '*'

    AliasesToExport = @()

    # DscResourcesToExport = @()

    # ModuleList = @()

    # FileList = @()

    PrivateData = @{
        PSData = @{
            Tags = @('tm1', 'planning analytics', 'powershell', 'ibm', 'rest-api')

            LicenseUri = 'https://github.com/ichermak/TM1ps/blob/master/LICENSE'

            ProjectUri = 'https://github.com/ichermak/TM1ps'

            IconUri    = 'https://github.com/ichermak/TM1ps/blob/master/Images/TM1ps.png'

            ReleaseNotes = 'https://github.com/ichermak/TM1ps'
        }
    }

    # HelpInfoURI = ''

    DefaultCommandPrefix = ''
}