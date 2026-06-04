{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00646') }},
        {{ ref('model_00627') }}
)
select id, 'model_01049' as name from sources
