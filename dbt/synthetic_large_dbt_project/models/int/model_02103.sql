{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01372') }},
        {{ ref('model_01138') }},
        {{ ref('model_01448') }}
)
select id, 'model_02103' as name from sources
