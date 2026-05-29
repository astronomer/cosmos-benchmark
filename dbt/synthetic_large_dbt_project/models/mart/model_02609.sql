{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01721') }},
        {{ ref('model_01926') }}
)
select id, 'model_02609' as name from sources
