
#include std\mysql;

mysql_test()
{
	host = "127.0.0.1";
	user = "3123123";
	pass = "3213123";
	db = "3124124";
	port = 3306;
	
	theQuery = "SELECT * FROM players";
	theQuery = "SELECT 1 as first,2 as second,3 as third UNION SELECT 11,22,33";
	
	mysql = mysql_init();
	printf("mysql="+mysql+"\n");
	ret = mysql_real_connect(mysql, host, user, pass, db, port);
	if (!ret)
	{
		printf("errno="+mysql_errno(mysql) + " error=''"+mysql_error(mysql) + "''\n");
		mysql_close(mysql);
		return 0;
	}
	
	printf("affected_rows="+mysql_affected_rows(mysql)+"\n");
	
	ret = mysql_query(mysql, theQuery);
	if (ret != 0)
	{
		printf("errno="+mysql_errno(mysql) + " error=''"+mysql_error(mysql) + "''\n");
		mysql_close(mysql);
		return 0;
	}
	
	result = mysql_store_result(mysql);
	
	printf("num_rows="+mysql_num_rows(result) + " num_fields="+mysql_num_fields(result)+"\n");
	
	mysql_field_seek(result, 0);
	while (1)
	{
		result_name = mysql_fetch_field(result);
		if (!isString(result_name))
			break;
		printf("field-name=" + result_name+"\n");
	}
	
	while (1)
	{
		row = mysql_fetch_row(result);
		if (!isDefined(row))
		{
			//printf("row == undefined\n");
			break;
		}
		output = "";
		for (i=0; i<row.size; i++)
			output += row[i] + " ";
		printf(output+"\n");
	}
	
	mysql_free_result(result);
	
	mysql_close(mysql);
			
}

mysql_test_ps()
{
	host = "127.0.0.1";
	user = "kung";
	pass = "zetatest";
	db = "kung_zeta";
	port = 3306;
	
	theQuery = "SELECT * FROM players";
	theQuery = "SELECT 1 as first,2 as second,3 as third UNION SELECT 11,22,33";
	
	mysql = mysql_init();
	printf("mysql="+mysql+"\n");
	ret = mysql_real_connect(mysql, host, user, pass, db, port);
	if (!ret)
	{
		printf("errno="+mysql_errno(mysql) + " error=''"+mysql_error(mysql) + "''\n");
		mysql_close(mysql);
		return 0;
	}
	
	mysql_stmt = mysql_stmt_init(mysql);
	printf("mysql_stmt = mysql_stmt_init() ret="+mysql_stmt + "\n");
		
	sql = "SELECT 1 + ?,1+? UNION SELECT 2+?,1 UNION SELECT 3,2 UNION SELECT 4,3";
	ret = mysql_stmt_prepare(mysql_stmt, sql, sql.size);
	printf("mysql_stmt_prepare(mysql_stmt, sql, sql.size) ret=" + ret + "\n");

	stmt_id = mysql_stmt_get_stmt_id(mysql_stmt);
	prefetch_rows = mysql_stmt_get_prefetch_rows(mysql_stmt);
	param_count = mysql_stmt_get_param_count(mysql_stmt);
	field_count = mysql_stmt_get_field_count(mysql_stmt);
	// 1,1,3,2:
	printf("stmt_id=" + stmt_id + " prefetch_rows=" + prefetch_rows + " param_count=" + param_count + " field_count=" + field_count + "\n");
	
	
	
	
	/*
	sizeof(MYSQL_BIND)=64
	MYSQL_TYPE_LONG=3
	offsetof(MYSQL_BIND, buffer_type)=52
	offsetof(MYSQL_BIND, buffer)=8
	offsetof(MYSQL_BIND, is_unsigned)=57
	offsetof(MYSQL_BIND, is_null)=4
	offsetof(MYSQL_BIND, length)=0
	*/
	sizeof_MYSQL_BIND = 64;
	MYSQL_TYPE_LONG = 3;
	offsetof_MYSQL_BIND_buffer_type = 52;
	offsetof_MYSQL_BIND_buffer = 8;
	offsetof_MYSQL_BIND_is_unsigned = 57;
	offsetof_MYSQL_BIND_is_null = 4;
	offsetof_MYSQL_BIND_length = 0;
	
	/*
	param[0].buffer_type = MYSQL_TYPE_LONG;
	param[0].buffer = (void*) &paramIntA;
	param[0].is_unsigned = 0;
	param[0].is_null = 0;
	param[0].length = 0;
	*/
	
	// MAKE A SPAWNSTRUCT-CLASS OUT OF IT var get(), var set(123)
	
	paramIntA = memory_malloc(4);
	paramIntB = memory_malloc(4);
	paramIntC = memory_malloc(4);
	
	resultIntA = memory_malloc(4);
	resultIntB = memory_malloc(4);
	
	
	param = memory_malloc(param_count * sizeof_MYSQL_BIND);
	
	memory_memset(param, 0, param_count * sizeof_MYSQL_BIND);
	
	memory_int_set(param + 0 * sizeof_MYSQL_BIND + offsetof_MYSQL_BIND_buffer_type, MYSQL_TYPE_LONG);
	memory_int_set(param + 0 * sizeof_MYSQL_BIND + offsetof_MYSQL_BIND_buffer, paramIntA);
	memory_int_set(param + 0 * sizeof_MYSQL_BIND + offsetof_MYSQL_BIND_is_unsigned, 0);
	memory_int_set(param + 0 * sizeof_MYSQL_BIND + offsetof_MYSQL_BIND_is_null, 0);
	memory_int_set(param + 0 * sizeof_MYSQL_BIND + offsetof_MYSQL_BIND_length, 0);

	memory_int_set(param + 1 * sizeof_MYSQL_BIND + offsetof_MYSQL_BIND_buffer_type, MYSQL_TYPE_LONG);
	memory_int_set(param + 1 * sizeof_MYSQL_BIND + offsetof_MYSQL_BIND_buffer, paramIntB);
	memory_int_set(param + 1 * sizeof_MYSQL_BIND + offsetof_MYSQL_BIND_is_unsigned, 0);
	memory_int_set(param + 1 * sizeof_MYSQL_BIND + offsetof_MYSQL_BIND_is_null, 0);
	memory_int_set(param + 1 * sizeof_MYSQL_BIND + offsetof_MYSQL_BIND_length, 0);

	memory_int_set(param + 2 * sizeof_MYSQL_BIND + offsetof_MYSQL_BIND_buffer_type, MYSQL_TYPE_LONG);
	memory_int_set(param + 2 * sizeof_MYSQL_BIND + offsetof_MYSQL_BIND_buffer, paramIntC);
	memory_int_set(param + 2 * sizeof_MYSQL_BIND + offsetof_MYSQL_BIND_is_unsigned, 0);
	memory_int_set(param + 2 * sizeof_MYSQL_BIND + offsetof_MYSQL_BIND_is_null, 0);
	memory_int_set(param + 2 * sizeof_MYSQL_BIND + offsetof_MYSQL_BIND_length, 0);
	
	ret = std\mysql::mysql_stmt_bind_param(mysql_stmt, param);
	printf("mysql_stmt_bind_param(mysql_stmt, param) ret=" + ret + "\n");
	
	
	
	
	result = memory_malloc(field_count * sizeof_MYSQL_BIND);
	
	memory_memset(result, 0, field_count * sizeof_MYSQL_BIND);
	
	memory_int_set(result + 0 * sizeof_MYSQL_BIND + offsetof_MYSQL_BIND_buffer_type, MYSQL_TYPE_LONG);
	memory_int_set(result + 0 * sizeof_MYSQL_BIND + offsetof_MYSQL_BIND_buffer, resultIntA);
	memory_int_set(result + 0 * sizeof_MYSQL_BIND + offsetof_MYSQL_BIND_is_unsigned, 0);
	memory_int_set(result + 0 * sizeof_MYSQL_BIND + offsetof_MYSQL_BIND_is_null, 0);
	memory_int_set(result + 0 * sizeof_MYSQL_BIND + offsetof_MYSQL_BIND_length, 0);

	memory_int_set(result + 1 * sizeof_MYSQL_BIND + offsetof_MYSQL_BIND_buffer_type, MYSQL_TYPE_LONG);
	memory_int_set(result + 1 * sizeof_MYSQL_BIND + offsetof_MYSQL_BIND_buffer, resultIntB);
	memory_int_set(result + 1 * sizeof_MYSQL_BIND + offsetof_MYSQL_BIND_is_unsigned, 0);
	memory_int_set(result + 1 * sizeof_MYSQL_BIND + offsetof_MYSQL_BIND_is_null, 0);
	memory_int_set(result + 1 * sizeof_MYSQL_BIND + offsetof_MYSQL_BIND_length, 0);
	
	ret = std\mysql::mysql_stmt_bind_result(mysql_stmt, result);
	printf("mysql_stmt_bind_result(mysql_stmt, result) ret=" + ret + "\n");
	
	
	memory_int_set(paramIntA, 10);
	memory_int_set(paramIntB, 20);
	memory_int_set(paramIntC, 30);
	
	std\mysql::mysql_stmt_execute(mysql_stmt);
	std\mysql::mysql_stmt_store_result(mysql_stmt);
	
	std\mysql::mysql_stmt_fetch(mysql_stmt);
	a = memory_int_get(resultIntA);
	b = memory_int_get(resultIntB);
	printf("a=" + a + " b=" + b + "\n");
	
	std\mysql::mysql_stmt_fetch(mysql_stmt);
	a = memory_int_get(resultIntA);
	b = memory_int_get(resultIntB);
	printf("a=" + a + " b=" + b + "\n");
	
	ret = mysql_stmt_close(mysql_stmt);
	printf("mysql_stmt_close(mysql_stmt) ret=" + ret + "\n");
	
	
	
	printf("affected_rows="+mysql_affected_rows(mysql)+"\n");
	
	ret = mysql_query(mysql, theQuery);
	if (ret != 0)
	{
		printf("errno="+mysql_errno(mysql) + " error=''"+mysql_error(mysql) + "''\n");
		mysql_close(mysql);
		return 0;
	}
	
	result = mysql_store_result(mysql);
	
	printf("num_rows="+mysql_num_rows(result) + " num_fields="+mysql_num_fields(result)+"\n");
	
	mysql_field_seek(result, 0);
	while (1)
	{
		result_name = mysql_fetch_field(result);
		if (!isString(result_name))
			break;
		printf("field-name=" + result_name+"\n");
	}
	
	while (1)
	{
		row = mysql_fetch_row(result);
		if (!isDefined(row))
		{
			//printf("row == undefined\n");
			break;
		}
		output = "";
		for (i=0; i<row.size; i++)
			output += row[i] + " ";
		printf(output+"\n");
	}
	
	mysql_free_result(result);
	
	mysql_close(mysql);
			
}