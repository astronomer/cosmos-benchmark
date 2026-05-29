{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01769') }},
        {{ ref('model_02058') }},
        {{ ref('model_01950') }}
)
select id, 'model_02430' as name from sources
