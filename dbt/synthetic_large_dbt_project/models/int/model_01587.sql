{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01099') }},
        {{ ref('model_00965') }}
)
select id, 'model_01587' as name from sources
