const fs = require('fs');
const yaml = require('js-yaml');

function generateMermaid(workflowPath) {
  const content = fs.readFileSync(workflowPath, 'utf8');
  const wf = yaml.load(content);
  
  let mermaid = `graph TD\n`;
  
  // Workflow box
  mermaid += `  A[📋 ${wf.name || 'Reusable Workflow'}]\n`;
  
  // Jobs
  Object.keys(wf.jobs || {}).forEach(jobId => {
    const job = wf.jobs[jobId];
    const jobColor = job.needs ? 'blue' : 'green';
    mermaid += `  ${jobId}[💼 ${jobId}]:::${jobColor}\n`;
    
    // Steps
    (job.steps || []).slice(0, 5).forEach((step, i) => {  // Limit to 5 steps
      const stepId = `${jobId}-s${i}`;
      const label = step.name || step.run || 'action';
      const shape = step.uses ? '🧩' : '⚙️';
      mermaid += `  ${stepId}[${shape} ${label.substring(0,20)}...]\n`;
      mermaid += `  ${jobId} --> ${stepId}\n`;
    });
  });
  
  // Color styles
  mermaid += `
    classDef blue fill:#4A90E2
    classDef green fill:#7ED321
  `;
  
  return mermaid;
}

// ---- CLI entrypoint ----
if (require.main === module) {
  const wfPath = process.argv[2];
  if (!wfPath) {
    console.error('Usage: node generate-diagram.js <workflow-file>');
    process.exit(1);
  }
  const diagram = generateMermaid(wfPath);
  process.stdout.write(diagram);
}
