using System;
using System.Collections.Generic;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;
using Microsoft.Azure.WebJobs.Extensions.Sql;
using Newtonsoft.Json;

namespace func_sample
{
    public class ToDoItem
    {
        [JsonProperty("id")]
        public Guid Id { get; set; }
        
        [JsonProperty("order")]
        public int? Order { get; set; }
        
        [JsonProperty("title")]
        public string Title { get; set; }
        
        [JsonProperty("url")]
        public string Url { get; set; }
        
        [JsonProperty("completed")]
        public bool? Completed { get; set; }
    }

    public class Test
    {
        [FunctionName("ProcessChanges")]
        public static void Run(
            [SqlTrigger("[dbo].[todos]", ConnectionStringSetting = "SqlConnectionString")] IReadOnlyList<SqlChange<ToDoItem>> changes,
            ILogger logger)
        {            
            foreach (SqlChange<ToDoItem> change in changes)
            {                
                ToDoItem toDoItem = change.Item;
                logger.LogInformation($"Change operation: {change.Operation}");
                logger.LogInformation($"Id: {toDoItem.Id}, Title: {toDoItem.Title}, Url: {toDoItem.Url}, Completed: {toDoItem.Completed}");
            }
        }
    }
}
