
local current_epics_metric = monitoring.gauge("epic_current_running", "count of currently running epics")
local current_epics = 0

local executed_blocks_enter = monitoring.counter("epic_executed_block_enter", "count of executed block_enter")
local executed_blocks_check = monitoring.counter("epic_executed_block_check", "count of executed block_check")
local executed_blocks_exit = monitoring.counter("epic_executed_block_exit", "count of executed block_exit")

local time_budget = monitoring.counter("epic_time_budget", "count of microseconds used in cpu time")

local epic_starts = monitoring.counter("epic_started", "count of started epics")
local exited_normally = monitoring.counter("epic_exited", "count of normally exited epics")
local exited_abort = monitoring.counter("epic_aborted", "count of aborted epics")

epic.register_hook({
  on_execute_epic = function()
    epic_starts.inc()
    current_epics = current_epics + 1
    current_epics_metric.set(current_epics)
  end,

  on_before_node_enter = function()
    executed_blocks_enter.inc()
  end,

  on_before_node_check = function()
    executed_blocks_check.inc()
  end,

  on_before_node_exit = function()
    executed_blocks_exit.inc()
  end,

  on_epic_exit = function()
    exited_normally.inc()
    current_epics = current_epics - 1
    current_epics_metric.set(current_epics)
  end,

  on_epic_abort = function()
    exited_abort.inc()
    current_epics = current_epics - 1
    current_epics_metric.set(current_epics)
  end,

  globalstep_stats = function(stats)
    time_budget.inc(stats.time)
  end
})
