extends Node

class Logger:
    var i_node: Node
    var i_node_name: StringName = &""
    var i_script_path: StringName

    func _init(node: Node) -> void:
        i_node = node
        i_script_path = node.script.get_path()

    func log(message: String):
        if i_node_name.is_empty():
           i_node_name = i_node.name
        var args = [
            Time.get_datetime_string_from_system(false, true),
            i_script_path,
            i_node_name,
            message
        ]
        print("%s [%s | %s] %s" % args)

func make_logger(node: Node) -> Logger:
    return Logger.new(node)
