{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02245') }},
        {{ ref('model_01727') }}
)
select id, 'model_02960' as name from sources
