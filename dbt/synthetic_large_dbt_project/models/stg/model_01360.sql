{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00127') }},
        {{ ref('model_00669') }}
)
select id, 'model_01360' as name from sources
