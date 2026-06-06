{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00709') }},
        {{ ref('model_00407') }}
)
select id, 'model_01464' as name from sources
