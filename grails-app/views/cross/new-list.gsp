<!--
  tranSMART - translational medicine data mart
  
  Copyright 2008-2012 Janssen Research & Development, LLC.
  
  This product includes software developed at Janssen Research & Development, LLC.
  
  This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License 
  as published by the Free Software  * Foundation, either version 3 of the License, or (at your option) any later version, along with the following terms:
  1.	You may convey a work based on this program in accordance with section 5, provided that you retain the above notices.
  2.	You may convey verbatim copies of this program code as you receive it, in any medium, provided that you retain the above notices.
  
  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS    * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
  
  You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
  
 
-->

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Strict//EN">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link rel="shortcut icon" href="${resource(dir:'images',file:'searchtool.ico')}">
		<link rel="icon" href="${resource(dir:'images',file:'searchtool.ico')}">
		<link rel="stylesheet" href="${resource(dir:'js', file:'ext/resources/css/ext-all.css')}">
		<link rel="stylesheet" href="${resource(dir:'js', file:'ext/resources/css/xtheme-gray.css')}">
		<link rel="stylesheet" href="${resource(dir:'css', file:'main.css')}">
		
	<!--[if IE 7]>
		<style type="text/css">
			div#gfilterresult,div#ptfilterresult,  div#jubfilterresult, div#dqfilterresult { width: 99%; }
			div#summary-div { margin-bottom:5px; }
		</style>
	<![endif]-->

        <script type="text/javascript" src="${resource(dir:'js', file:'prototype.js')}"></script>
        <script type="text/javascript" src="${resource(dir:'js', file:'ext/adapter/ext/ext-base.js')}"></script>
        <script type="text/javascript" src="${resource(dir:'js', file:'ext/ext-all.js')}"></script>
        <script type="text/javascript" src="${resource(dir:'js', file:'ext/miframe.js')}"></script>
        <script type="text/javascript" src="${resource(dir:'js', file:'filtertree.js')}"></script>
        <script type="text/javascript" src="${resource(dir:'js', file:'maintabncibipanel.js')}"></script>
        <script type="text/javascript" src="${resource(dir:'js', file:'toggle.js')}"></script>
        <script type="text/javascript" src="${resource(dir:'js', file:'searchcombobox.js')}"></script>
        <script type="text/javascript" src="${resource(dir:'js', file:'picklist.js')}"></script>
        <script type="text/javascript" src="${resource(dir:'js', file:'editfilterswindow.js')}"></script>
        <script type="text/javascript" src="${resource(dir:'js', file:'utilitiesMenu.js')}"></script>

		<script type="text/javascript" charset="utf-8">
			Ext.BLANK_IMAGE_URL = "${resource(dir:'js', file:'ext/resources/images/default/s.gif')}";

			// set ajax to 90*1000 milliseconds
			Ext.Ajax.timeout = 180000;

			// this overrides the above
			Ext.Updater.defaults.timeout = 180000;

			// qtip on
			Ext.QuickTips.init();


			// Create global object to pass all the counts and urls to the main tab panel
			var pageData = {
				//activeTab: "${session.searchFilter.acttab()}",
				//default to 0
				activeTab:"0" ,
				// flag to hideInternal tabs as well as the export resnet button
				<sec:ifAnyGranted roles="ROLE_PUBLIC_USER">
			         hideInternal:true,
				</sec:ifAnyGranted>
				<sec:ifNotGranted roles="ROLE_PUBLIC_USER">
				     hideInternal:false,
				</sec:ifNotGranted>
				trial: { // tab1 - see maintabpanel.js
				    count: 0,
				    analysisCount: 0,
				    resultsUrl: "${createLink(controller:'trial', action:'datasourceTrial')}",
				    teaResultsUrl: "${createLink(controller:'trial', action:'datasourceTrialTEA')}",
				    filterUrl: "${createLink(controller:'trial', action:'showTrialFilter')}"
			    },
				pretrial: { // tab2 - see maintabpanel.js
				    count: 0,
				    mRNAAnalysisCount: 0,
				    resultsUrl: "${createLink(controller:'experimentAnalysis', action:'datasourceResult')}",
				    teaResultsUrl: "${createLink(controller:'experimentAnalysis', action:'datasourceResultTEA')}",
				    filterUrl: "${createLink(controller:'experimentAnalysis', action:'showFilter')}"
				},
				profile: { // tab3 - see maintabpanel.js
				    count: 0,
				    resultsUrl: "${createLink(controller:'expressionProfile', action:'datasourceResult')}"
				},
			    jubilant: { // tab4 - see maintabpanel.js
				    activeCard: 0,
				    resultsUrl: "${createLink(controller:'literature', action:'datasourceJubilant')}",
				    filterUrl: "${createLink(controller:'literature', action:'showJubFilter')}",
				    count: 0,
				    litJubOncAltCount: 0,
				    litJubOncIntCount: 0,
				    litJubAsthmaIntCount: 0,
				    jubOncologyAlterationUrl: "${createLink(controller:'literature', action:'datasourceJubOncologyAlteration')}",
				    jubOncologyInhibitorUrl: "${createLink(controller:'literature', action:'datasourceJubOncologyInhibitor')}",
				    jubOncologyInteractionUrl: "${createLink(controller:'literature', action:'datasourceJubOncologyInteraction')}"
			    },
			    doc: {  // tab5 - see maintabpanel.js
				    count: 0,
				    resultsUrl: "${createLink(controller:'document', action:'datasourceDocument')}",
				    filterUrl: "${createLink(controller:'document', action:'showDocumentFilter')}"
			    },
			    pictor: { // tab 6 - see maintabpanel.js
			   		<g:if test="${session.searchFilter.pictorTerms != null}">
						resultsUrl: "${grailsApplication.config.com.recomdata.searchtool.pictorURL}" + "&symbol=${session.searchFilter.pictorTerms}"
	    			</g:if>
					<g:else>
	                	resultsUrl: "${createLink(controller:'search',action:'noResult')}"
					</g:else>
			    },

			    resnet: { // tab 7 - see maintabpanel.js
			   		resultsUrl: "${grailsApplication.config.com.recomdata.searchtool.pathwayStudioURL}" + "/app/op?.name=comprehensiveSearch&query=${session.searchFilter.getExternalTerms()}",
			   		credentials: "ID/Password=Pathway Studio ID/Password"
			    },
			    genego: { // tab 8 - see maintabpanel.js
					resultsUrl: "${grailsApplication.config.com.recomdata.searchtool.genegoURL}" + "/cgi/search/ez.cgi?submitted=1&name=${session.searchFilter.getExternalTerms()}",
					credentials: "User name/Password= Your GeneGo Metacore user name/password"
			    },
				metscape: { // tab9 - see maintabpanel.js
					count: 0,
					inputUrl:"${createLink(controller:'metScape', action:'gene')}"
				},
				conceptExplorer: { // tab10 - see maintabpanel.js
					count: 0,
					inputUrl:"${createLink(controller:'conceptExplorer', action:'searchws')}"
				},
				metab2mesh: { // tab11 - see maintabpanel.js
					count: 0,
					inputUrl:"${createLink(controller:'metab2Mesh', action:'index')}"
				},
				gene2mesh: { // tab11 - see maintabpanel.js
					count: 0,
					inputUrl:"${createLink(controller:'gene2Mesh', action:'index')}"
				},
			    session: { // tab12 - see maintabpanel.js
				    resultsUrl: "${createLink(controller:'sessionInfo', action:'index')}"
				},
			    trialFilterUrl: "${createLink(controller:'trial',action:'trialFilterJSON')}",
			    jubSummaryUrl: "${createLink(controller:'literature',action:'jubSummaryJSON')}",
				heatmapUrl: "${createLink(controller:'heatmap',action:'initheatmap')}",
				downloadJubSummaryUrl: "${createLink(controller:'literature',action:'downloadJubData')}",
				downloadResNetUrl: "${createLink(controller:'literature',action:'downloadresnet')}",
				downloadTrialStudyUrl: "${createLink(controller:'trial', action:'downloadStudy')}",
				downloadTrialAnalysisUrl: "${createLink(controller:'trial', action:'downloadAnalysisTEA')}",
				downloadEaUrl: "${createLink(controller:'experimentAnalysis', action:'downloadAnalysis')}",
				downloadEaTEAUrl: "${createLink(controller:'experimentAnalysis', action:'downloadAnalysisTEA')}"
				};

			Ext.onReady(function(){
			    try {
			    document.execCommand("BackgroundImageCache", false, true);
			    } catch(err) {}


				var picklist = new Ext.app.PickList({
					id: "categories",
//					cls: "categories-gray",
					storeUrl: "${createLink([controller:'cross',action:'loadCategories'])}",
					renderTo: "cross-categories",
					label: "Category:&nbsp;",
					disabledClass: "picklist-disabled",
					onSelect: function(record) {
				        var combo = Ext.getCmp("cross-combobox");
				        combo.focus();
				        if ((record.id != "all") || (record.id == "all" && combo.getRawValue().length > 0)) {
							combo.doQuery(combo.getRawValue(), true);
				        }
					}
				});

				var combo = new Ext.app.SearchComboBox({
					id: "cross-combobox",
					renderTo: "cross-text",
					searchUrl: "${createLink([action:'loadSearch',controller:'cross'])}",
					submitUrl: "${createLink([action:'newSearch',controller:'cross'])}",
					submitFn: function(param, text) {
						var combo = Ext.getCmp("cross-combobox");
						combo.setDisabled(true);
						combo.setRawValue("Searching for " + text + "...");
						var searchbtn = document.getElementById("cross-button");
						searchbtn.disabled = true;
						var picklist = Ext.getCmp("categories");
						picklist.setDisabled(true);
//						var linkbuttons = document.getElementById("linkbuttons-div");
//						linkbuttons.innerHTML = '<span style="color:#a0a0a0;font-size:11px;text-decoration:underline;">browse<br />saved filters</span>';
						var idfield = document.getElementById("id-field");
						idfield.value = param;
						setTimeout("postSubmit();", 100);
						document.form.submit();
					},
					value: "${session?.searchFilter?.searchText}",
					width: 470,
			        onSelect: function(record) {
						this.collapse();
						if (record != null) {
							this.submitFn(record.data.id, record.data.keyword);
						}
					},
			        listeners: {
						"beforequery": {
							fn: function(queryEvent) {
					            var picklist = Ext.getCmp("categories");
					            if (picklist != null) {
						            var rec = picklist.getSelectedRecord();
									if (rec != null) {
										queryEvent.query = rec.id + ":" + queryEvent.query;
									}
								}
							},
							scope: this
						}
			        }
				});
				//combo.focus();

                var win = new Ext.app.EditFiltersWindow({
                    id: "editfilters-window",
                    loadUrl: "${createLink([action:'loadCurrentFilters',controller:'cross'])}",
                    splitUrl: "${createLink([action:'loadPathwayFilters',controller:'cross'])}",
                    searchUrl: "${createLink([action:'loadSearch',controller:'cross'])}",
                    submitUrl: "${createLink([action:'searchEdit',controller:'cross'])}",
                    categoriesUrl: "${createLink([controller:'cross',action:'loadCategories'])}"
                });

				// build search tabs and toolbar
				var tabpanel = createMainTabNcibiPanel();
				var hideInternalTabs = "${grailsApplication.config.com.recomdata.searchtool.hideInternalTabs}";
				
				if ((pageData.hideInternal == true) || hideInternalTabs=="true")  {
				    tabpanel.remove(Ext.getCmp("tab1"));
				    tabpanel.remove(Ext.getCmp("tab3"));
				    tabpanel.remove(Ext.getCmp("tab4"));
				    tabpanel.remove(Ext.getCmp("tab5"));
					tabpanel.remove(Ext.getCmp("tab6"));
				    tabpanel.remove(Ext.getCmp("tab7"));
				} else  {
					// All tabs should show only if the external configuration is correct
					if ("${grailsApplication.config.com.recomdata.searchtool.pictorURL}" == "")    {
						tabpanel.remove(Ext.getCmp("tab6"));
					}
				    if ("${grailsApplication.config.com.recomdata.searchtool.pathwayStudioURL}" == "")  {
					    tabpanel.remove(Ext.getCmp("tab7"));
				    }
				    if ("${grailsApplication.config.com.recomdata.searchtool.genegoURL}" == "") {
				        tabpanel.remove(Ext.getCmp("tab8"));
					}				       
				}

				// remove all non-ncibi tabs
				tabpanel.remove(Ext.getCmp("tab1"));
				tabpanel.remove(Ext.getCmp("tab2"));
			    tabpanel.remove(Ext.getCmp("tab3"));
			    tabpanel.remove(Ext.getCmp("tab4"));
				tabpanel.remove(Ext.getCmp("tab6"));
			    tabpanel.remove(Ext.getCmp("tab7"));
			    tabpanel.remove(Ext.getCmp("tab8"));
				
				// disable the MetScape tab if the search result is not a gene??
				if(${session.searchFilter.globalFilter.getGeneFilters().size()} == 0) {
					 tabpanel.remove(Ext.getCmp("tab9"));
				}
				
			    // set active tab
			    tabpanel.activate(getActiveTab("${session.searchFilter.acttabname()}"));

                var helpURL = '${grailsApplication.config.com.recomdata.searchtool.adminHelpURL}';
                var contact = '${grailsApplication.config.com.recomdata.searchtool.contactUs}';
                var appTitle = '${grailsApplication.config.com.recomdata.searchtool.appTitle}';
//                var buildVer = 'Build Version: <g:meta name="environment.BUILD_NUMBER"/> - <g:meta name="environment.BUILD_ID"/>';
				var buildVer = 'Build Version: NCIBI Demo - V1.1.0';
				
                var viewport = new Ext.Viewport({
                    layout: "border",
                    items:[new Ext.Panel({
                        region: "north",
                        tbar: createUtilitiesMenu(helpURL, contact, appTitle,'${request.getContextPath()}', buildVer, 'utilities-div'),
                        contentEl: "header-div"
                    }),
                        new Ext.Panel({
                            layout: "fit",
                            region: "center",
                            items: [ tabpanel ]
                        })
                    ]
                });
                viewport.doLayout();
			});

            var delayedTask = new Ext.util.DelayedTask();

            function searchOnClick() {
				var combo = Ext.getCmp("search-combobox");
				var param = combo.getSelectedParam();
				if (param != null) {
					combo.submitFn(param, param);
				}
			}

			function postSubmit() {
				var searchcombo = document.getElementById("cross-combobox");
				searchcombo.className += " searchcombobox-disabled";
				searchcombo.style.width = "442px";
			}

            function removeFilter(id) {
                window.location = String.format("${createLink([controller:'search',action:'remove'])}" + "?id={0}", id);
            }

            function splitFilter(id) {
            }

			function getActiveTab(sourceName){

				var hideInternalTabs = "${grailsApplication.config.com.recomdata.searchtool.hideInternalTabs}";
					
				var tab = 0;
				if ((pageData.hideInternal == true) || hideInternalTabs=="true")  {
					/*if(sourceName=="trial")
						tab =-1;
					else if(sourceName=="pretrial")
						tab = 0;
					else if(sourceName =="profile")
						tab = 0;
					else if(sourceName =="jubilant")
						tab = 0;
					else if(sourceName =="doc")
						tab =0;
					else
						tab =0; */
					tab = 0;
				}else{
		
			// normal tab
				if(sourceName=="trial")
					tab =0;
				else if(sourceName=="pretrial")
					tab = 1;
				else if(sourceName =="profile")
					tab = 2;
				else if(sourceName =="jubilant")
					tab = 3;
				else if(sourceName =="doc")
					tab =4;
				else
					tab =5;
				
				}
				// override until we figure out what to do
				tab = 0;
				return tab;
				
			}
			
		</script>
		<title>${grailsApplication.config.com.recomdata.searchtool.appTitle}</title>
		<!-- ************************************** -->
        <!-- This implements the Help functionality -->
        <script type="text/javascript" src="${resource(dir:'js', file:'help/D2H_ctxt.js')}"></script>
        <script language="javascript">
        	helpURL = '${grailsApplication.config.com.recomdata.searchtool.adminHelpURL}';
        </script>
		<!-- ************************************** -->
	</head>
	<body>
		<div id="header-div">
			<g:render template="/layouts/commonheader" model="['app':'cross']" />
			<g:render template="/layouts/crossheader" model="['app':'cross']" />
            <div id="summarycount-div" style="background:#dfe8f6; color:#000; padding:5px 10px 5px 10px;border-top:1px solid #36c;">
                <span id="summarycount-span" style="font-size:13px; font-weight:bold;">
                    About ${searchresult?.totalCount()} results found
                </span>
            </div>
            <div id="ncibi-summary-div" style="padding:5px 10px 5px 10px;font-size:12px;line-height:17px;">
                <b>Filters:</b>&nbsp;${session?.searchFilter?.summaryWithLinks}
            &nbsp;<a class="tiny" style="text-decoration:underline;color:blue;font-size:11px;"
                     href="#" onclick="var win=Ext.getCmp('editfilters-window');win.show();return false;">advanced</a>
                &nbsp;<a class="tiny" style="text-decoration:underline;color:blue;font-size:11px;"
                         href="${createLink(controller:'customFilter', action:'create')}">save</a>
                &nbsp;<a class="tiny" style="text-decoration:underline;color:blue;font-size:11px;"
                         href="${createLink(controller:'cross', action:'index')}">clear all</a>
            </div>
            <g:form controller="geneExprAnalysis" name="globalfilter-form" id="globalfilter-form" action="doSearch">
                <input type="hidden" name="selectedpath" value="">
            </g:form>
		</div>
	</body>
</html>
