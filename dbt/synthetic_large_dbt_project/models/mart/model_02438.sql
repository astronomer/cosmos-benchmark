{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02037') }},
        {{ ref('model_01548') }},
        {{ ref('model_02045') }}
)
select id, 'model_02438' as name from sources
