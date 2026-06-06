{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00547') }},
        {{ ref('model_00653') }},
        {{ ref('model_00487') }}
)
select id, 'model_00865' as name from sources
