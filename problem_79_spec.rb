require 'byebug'
require_relative 'problem_79'

describe Graph do

  let(:graph) { Graph.new }

  it "is created with no nodes" do
    expect(graph.nodes.size).to eq 0
  end

  it "can add nodes based on a value" do
    graph.add(7)
    expect(graph.nodes.size).to eq 1
  end

  it "can find nodes based on their values" do
    graph.add(7)
    node7 = graph.find(7)
    expect(node7.value).to eq 7
  end

  it "can find or create nodes by a value" do
    node1 = graph.find_or_create_by(7)

    expect(graph.nodes.size).to eq 1
    expect(node1.value).to eq 7

    node2 = graph.find_or_create_by(7)

    expect(node2.value).to eq 7
    expect(graph.nodes.size).to eq 1
  end

  it "will connect nodes directionally" do
    node7 = graph.add(7)
    node1 = graph.add(1)
    graph.connect(node7, node1)

    expect(node7.outgoing_edges.size).to eq 1
    expect(node1.incoming_edges.size).to eq 1
  end

  it "will disconnect nodes" do
    node7 = graph.add(7)
    node1 = graph.add(1)
    graph.connect(node7, node1)
    graph.disconnect(node7, node1)

    expect(node7.outgoing_edges.size).to eq 0
    expect(node1.incoming_edges.size).to eq 0
  end
end

