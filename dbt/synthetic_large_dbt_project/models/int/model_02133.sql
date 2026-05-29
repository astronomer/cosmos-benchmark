{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01268') }},
        {{ ref('model_01200') }},
        {{ ref('model_01343') }}
)
select id, 'model_02133' as name from sources
