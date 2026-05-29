{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02152') }},
        {{ ref('model_02099') }},
        {{ ref('model_01583') }}
)
select id, 'model_02929' as name from sources
