{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01828') }},
        {{ ref('model_02039') }},
        {{ ref('model_02076') }}
)
select id, 'model_02512' as name from sources
