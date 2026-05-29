{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01950') }},
        {{ ref('model_01770') }},
        {{ ref('model_01594') }}
)
select id, 'model_02257' as name from sources
