
t_ = {}

t_.verbose = false

t_.set_verbose = (status) ->
  if status == "on" then
    t_.verbose = "on"
  else
    t_.verbose = nil

t_.set = (list) ->
  set = {}
  for _,l in ipairs(list)
    set[l] = true
  set

-- Converts a query result with columns id and name to set table
t_.catalog = (res) ->
  set = {}
  if table.getn(res)>0 then
    for k,v in pairs(res) 
      set[v.id]=v.name
  set

t_.numeric_keys = (res) ->
  set = {}
  if table.getn(res)>0 then
    for k,v in pairs(res) do
      set[k] = {}
      i = 1
      for k2,v2 in pairs(v) do
        set[k][i]=v2
        i += 1
  set

t_.dataTable= (session,query,params,columns,permissions_table) ->
  --INIT VARIABLES
  match=""
  res = ""
  filtered_res = {}
  search = ""
  length = ""
  filtered_length = ""
  start = ""
  draw = ""
  data = {}
  total = ""
  sort_col = ""
  sort_dir = ""

  --GETTING AL RECORDS
  --where=" WHERE (#{permissions_table}.r_owner=#{session.user_id} or ((#{permissions_table}.r_roles&#{session.user_role})> 0) or (((#{permissions_table}.permissions%10)&4)>0))  "
  --query ..= where
  res = db.query query
  total = table.getn(res)

  -- PARSING PARAMS
  -- set the search variable
  if params.sSearch != nil then
    search = enc_ent.escape tostring(params.sSearch)
  else
    search = false
  -- sort columns
  sort_col = tonumber(params.iSortCol_0) + 1
  sort_dir = params.sSortDir_0
  -- length
  length = tonumber params.iDisplayLength
  -- draw
  draw = params.sEcho
  -- start
  start = tonumber(params.iDisplayStart)+1


  -- INTERNAL SEARCH ON ALL FIELDS
  if search != false then
    for k,v in pairs res
      match = false
      for k2,v2 in pairs v
        --print "Buscando: '"..search.."' en '"..tostring(v2).."'"
        if string.match(tostring(v2),search) then
          match = true
      if match == true then
        table.insert filtered_res,v
  else
    filtered_res=res
  -- Counting filtered results
  filtered_length = table.getn(filtered_res)
  -- Converting to array
  res=t_.dataTable_numkeys(filtered_res,columns)
  filtered_res = res

  -- SORTING DATA
  res=t_.dataTable_sort(filtered_res,sort_col,sort_dir)
  filtered_res=res

  -- CUTTING RESULTS TO DISPLAY
  if table.getn(filtered_res) > tonumber(length) then
    res = {}
    for i=start,start+tonumber(length)-1 do
       table.insert(res,filtered_res[i])
    filtered_res = res

  ---- GENERATING RESPONSE Without fnServerData
  --data['draw']=draw
  --data['recordsTotal']=total
  --data['recordsFiltered']=filtered_length
  --data['data']=t_.dataTable_numkeys(filtered_res,columns)
  -- GENERATING RESPONSE
  data['sEcho']=draw
  data['iTotalRecords']=total
  data['iTotalDisplayRecords']=filtered_length
  data['aaData']=filtered_res

  --dumpvar.print data
  data

-- SORTING SELECTED COLUMN
t_.dataTable_sort= (data,column,dir) ->
  comp_asc = (f1,f2) ->
    if f1[column] < f2[column] then
      true

  comp_desc = (f1,f2) ->
    if f1[column] > f2[column] then
      true

  if dir == "asc" then
    table.sort(data,comp_asc)
  else
    table.sort(data,comp_desc)

  data

-- CONVERTING HASH KEYS TO ARRAY OF NUMBERS WITH columns ORDER
t_.dataTable_numkeys= (res,columns) ->
  set = {}
  if table.getn(res)>0 then
    for k,v in pairs(res) do
      set[k] = {}
      for k2,v2 in pairs(v) do
        set[k][columns[k2]]=v2
  set

t_.get_len= (t) ->
  count = 0
  if t
    for k,v in pairs t
      count += 1
  return count

return t_
