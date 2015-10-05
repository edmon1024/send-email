$(document).ready(function() {
    $('#scroll_table').DataTable( {
        "bProcessing" : true,
        "bDestroy" : true,
        "bAutoWidth" : true,
        "sScrollY" : "390",
        "sScrollX" : "100%",
        "bScrollCollapse" : true,
        "bSort" : true,
        "sPaginationType" : "full_numbers",
        "iDisplayLength" : 10
    } );

    $('#scroll_table_sside').DataTable( {
        "bProcessing" : true,
//        "bDestroy" : true,
//        "bAutoWidth" : true,
//        "sScrollY" : "390",
//        "sScrollX" : "100%",
//        "bScrollCollapse" : true,
//        "bSort" : true,
//        "sPaginationType" : "full_numbers",
//        "iDisplayLength" :10
        "bServerSide": true,
        "sAjaxSource": "/messages/retrieve",
        "fnServerData": function (sSource, aoData, fnCallback ) {
          $.ajax( {
            "dataType": 'json',
            "type": "POST",
            //"type": "GET",
            "url": "/messages/retrieve",
            "data": aoData,
            "success": fnCallback
          } );
        }
    });
});
