{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00782') }},
        {{ ref('model_00914') }}
)
select id, 'model_01829' as name from sources
