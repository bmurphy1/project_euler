# Build a Directed Acyclic Graph from the logins
# Sort the graph using Topological Sort
# TODO: GraphBuilder - import login file directly from projecteuler.net

require 'byebug'


class Node
  attr_accessor :value, :incoming_edges, :outgoing_edges

  def initialize(value)
    @value = value
    @incoming_edges = []
    @outgoing_edges = []
  end

  def print
      p self.value
      p "Incoming: #{self.incoming_edges.map {|n| n.value}}"
      p "Outgoing: #{self.outgoing_edges.map {|n| n.value}}"
  end
end


class Graph
  attr_accessor :nodes

  def initialize
    @nodes = []
  end

  def find(value)
    @nodes.find { |n| n.value == value }
  end

  def add(value)
    @nodes << Node.new(value)
    @nodes.last
  end

  def find_or_create_by(value)
    node = self.find(value)
    node ? node : self.add(value)
  end

  def delete(value)
    @nodes.delete_if { |n| n.value == value }
  end

  def adjacent?(a, b)
    a.edges.find { |e| e.node == b } ? true : false
  end

  def connect(a, b)
    a.outgoing_edges << b unless a.outgoing_edges.include?(b)
    b.incoming_edges << a unless b.incoming_edges.include?(a)
  end

  def disconnect(a, b)
    a.outgoing_edges.delete_if { |e| e == b }
    b.incoming_edges.delete_if { |e| e == a }
  end

  def print
    puts "******************"
    @nodes.each do |node|
      node.print
    end
  end
end


class GraphBuilder
  attr_accessor :filename

  def initialize(filename)
    @filename = filename
  end

  # Returns graph object with nodes built from logins in file
  def build_graph
    graph = Graph.new
    f = File.new(filename, "r")

    # Get every line,
    # cast to integer, split into array,
    # add nodes to graph for each integer,
    # ending with: [node1, node2, node3]
    while line = f.gets
      arr_of_nodes = line.chomp.split("").map do |value|
        graph.find_or_create_by(value.to_i)
      end

      arr_of_nodes.each_with_index do |node, i|
        next_node = arr_of_nodes[i+1]
        if next_node
          graph.connect(node, next_node)
        end
      end
    end
    f.close
    graph
  end
end


class TopSort

  # Topological sort
  def sort(graph)
    list = []
    s = starting_nodes(graph) # All nodes with no incoming edges
    until s.empty?
      # graph.print
      n = s.pop
      list << n.value
      edges = n.outgoing_edges.clone
      edges.each do |m|
        graph.disconnect(n, m)
        s << m if m.incoming_edges.empty?
      end
    end
    list
  end

  private

  # Returns all nodes with no incoming edges
  def starting_nodes(graph)
    graph.nodes.select { |node| node.incoming_edges.empty? }
  end
end



graph_builder = GraphBuilder.new("p079_keylog.txt")
graph = graph_builder.build_graph

top_sort = TopSort.new
p top_sort.sort(graph)


